%カラーヒストグラムを入力として最近傍法を用いた5分割クロスバリデーション
function NN_Food_accuracy(list)
    %positiven, negativeのカラーヒストグラム
    %dbロード(組み合わせの変更時に修正必須)
    data = load('db_ramen_curry.mat');
    training_data = data.database;
    
    %positive画像集合
    data_pos = training_data(1:100,:);
    %positiveの配列インデックス
    pos_index = [1:100];
    %negative画像集合(組み合わせの変更時に修正必須)
    data_neg = training_data(101:200,:);
    %negativeの配列インデックス(組み合わせの変更時に修正必須)
    neg_index = [101:200];
    
    %5-fold cross validation
    cv = 5;
    %positive画像インデックス
    idx1 = [1:100];
    %negative画像インデックス(組み合わせの変更時に修正必須)
    idx2 = [1:100];
    accuracy=[];
    
    % idx番目(idxはcvで割った時の余りがi-1)が評価データ
    % それ以外は学習データ
    for i=1:cv 
      train_pos= data_pos(find(mod(idx1,cv)~=(i-1)),:);
      eval_pos = data_pos(find(mod(idx1,cv)==(i-1)),:);
      train_index_pos = pos_index(find(mod(idx1,cv)~=(i-1)));
      eval_index_pos = pos_index(find(mod(idx1,cv)==(i-1)));
      train_neg = data_neg(find(mod(idx2,cv)~=(i-1)),:);
      eval_neg = data_neg(find(mod(idx2,cv)==(i-1)),:);
      train_index_neg = neg_index(find(mod(idx2,cv)~=(i-1)));
      eval_index_neg = neg_index(find(mod(idx2,cv)==(i-1)));
      %訓練データ
      train=[train_pos; train_neg];
      %テストデータ
      eval=[eval_pos; eval_neg];
      train_index = [train_index_pos train_index_neg];
      eval_index = [eval_index_pos eval_index_neg];
      %positiveを1, negativeを-1
      train_label=[ones(size(train_pos, 1),1); ones(size(train_neg, 1),1)*(-1)];
      eval_label =[ones(size(eval_pos, 1),1); ones(size(eval_neg, 1),1)*(-1)];
      
      correct = 0;
      eval_index_list = [];
      train_index_list = [];
      for j = 1:size(eval, 1)
          [index, val] = getMinDisIndex(eval(j,:), train);
          %ポジティブ画像をポジティブに分類 or ネガティブ画像をネガティブに分類
          if eval_label(j) == train_label(index)
              %分類成功
              correct = correct + 1;
              eval_index_list = [eval_index_list, j];
              train_index_list = [train_index_list, index];
          else
              %分類失敗
              %eval_index_list = [eval_index_list, j];
              %train_index_list = [train_index_list, index];
          end
      end
      %accuracy出力
      ac = correct/size(eval,1);
      fprintf('%d回目の正答率 : %f .\n',i,ac); 
      accuracy = [accuracy ac];
    end
    %分類精度の平均
    fprintf('accuracy: %f\n',mean(accuracy));
  
    %識別成功した最初の10枚について対応を表示
    for i = 1:5
         subplot(5, 2, (i-1)*2 + 1);
         imshow(imread(list{eval_index(eval_index_list(i))}));
         subplot(5, 2, (i-1)*2 + 2);
         imshow(imread(list{train_index(train_index_list(i))}));
    end
end