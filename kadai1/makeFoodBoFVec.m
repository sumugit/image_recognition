%BoFベクトル作成関数(画像枚数xクラスター数)
function training = makeFoodBoFVec(list)
    %コードブックのロード(組合わせ変更時に修正必須)
    load('codebook_ramen_soba.mat');
    %BoFベクトルの行列表現,(画像枚数, クラスター数)
    bovw=zeros(size(list,2),1000);
     for j=1:size(list,2)
        %SURF特徴抽出
        I=rgb2gray(imresize(imread(list{j}), [320 NaN]));
        %ランダムサンプリング
        p=createRandomPoints(I, 3000);
        [f,pnt]=extractFeatures(I,p);
        %各特徴量についてfor-loop
        for i=1:size(f,1)
          %各特徴量f(i,:)について,CODEBOOKから代表ベクトル(visual word)を探索
          [index, val] = getMinDisIndex(f(i,:), CODEBOOK);
          %度数更新
          bovw(j,index)=bovw(j,index)+1;
        end
     end
     training = bovw;
end