function SVM_kadai2_ranking(training_data, test_data, list2)
    tic;
    %positive画像は猫画像100枚, negative画像はそれ以外の画像100枚
    % 学習関数fitcsvm (linear(線形)カーネル，RBF(非線形)カーネル)
    training_label = [ones(50,1); ones(500,1)*(-1)];
    model = fitcsvm(training_data, training_label,'KernelFunction','linear'); 
    %model = fitcsvm(training_data, training_label,'KernelFunction','rbf');
    %テストデータで2値分類
    [label,score] = predict(model, test_data);
    % 降順 ('descent') でソートして，ソートした値とソートインデックスを取得します．
    [sorted_score,sorted_idx] = sort(score(:,2),'descend');
    
    % list{:} に画像ファイル名が入っているとして，
    % sorted_idxを使って画像ファイル名，さらに
    % sorted_score[i](=score[sorted_idx[i],2])の値を出力します．
    for i=1:numel(sorted_idx)
      fprintf('%s %f\n',list2{sorted_idx(i)},sorted_score(i));
    end
    toc;
end