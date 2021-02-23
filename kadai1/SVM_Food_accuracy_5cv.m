function SVM_Food_accuracy_5cv(training_data, list)
tic;
%positive画像集合
data_pos = training_data(1:100,:);
%positiveの配列インデックス
pos_index = [1:100];
%negative画像集合(組み合わせの変更時に修正必須)
data_neg = training_data(101:300,:);
%negativeの配列インデックス(組み合わせの変更時に修正必須)
neg_index = [101:300];

%5-fold cross validation
cv = 5;
%positive画像インデックス
idx1 = [1:100];
%negative画像インデックス(組み合わせの変更時に修正必須)
idx2 = [1:200];
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
    %学習
    model = fitcsvm(train, train_label,'KernelFunction','linear');
    %model = fitcsvm(train, train_label,'KernelFunction','rbf','KernelScale','auto');
    %検証データでテスト
    [predicted_label, scores] = predict(model, eval);
    %評価(認識精度値を出力)
    ac = numel(find(eval_label==predicted_label))/numel(eval_label);
    fprintf('%d回目の正答率 : %f .\n',i,ac);
    accuracy = [accuracy ac];
end
%分類精度の平均
fprintf('accuracy: %f\n',mean(accuracy));
%識別成功した最初の5枚について対応を表示
count = 0;
for i = 1:size(eval_label, 1)
    %誤って(or正しく)分類された10枚を表示
    if(eval_label(i)==predicted_label(i))
        count = count + 1;
        subplot(5, 2, count);
        imshow(imread(list{eval_index(i)}));
        if count == 10
            break;
        end
    end
end
toc;
end