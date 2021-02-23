%学習に使う全てのデータでコードブック作成
function y = makeFoodCodeBook(k)
    %画像pathのリスト作成
    n=0; list={};
    %食事画像の入ったフォルダ(組み合わせ変更時に修正必須)
    LIST={'img_ramen' 'img_soba'};
    DIR0='../';
    for i=1:length(LIST)
        DIR=strcat(DIR0,LIST(i),'/');
        %ディレクトリ移動
        W=dir(DIR{:});
    
        for j=1:size(W)
              %名前に.jpgを含むファイル
            if (strfind(W(j).name,'.jpg'))
                fn=strcat(DIR{:},W(j).name);
                n=n+1;
                %fprintf('[%d] %s\n',n,fn);
                %取り出す画像枚数(組み合わせ変更時に修正必須)
                list={list{:} fn};
                if n == 200
                    break;
                end
            end
        end
    end
    %SURF特徴抽出
   Features=[];
   for i=1:size(list,2)
    I=rgb2gray(imresize(imread(list{i}), [320 NaN]));
    %ランダムサンプリング
    p=createRandomPoints(I, 3000);
    [f,p2]=extractFeatures(I,p);
    %fは画像が64色に減色されており,64次元ベクトル
    Features=[Features; f];
   end
   %k-meansクラスラリング
   if size(Features, 1) > 50000
      sel=randperm(size(Features, 1),50000);
      Features=Features(sel,:); 
   end
   %COODBOOKは各クラスターの中心ベクトル集合
   [idx,CODEBOOK]=kmeans(Features,k);
   %コードブック保存(組み合わせ変更時に修正必須)
   save('codebook_ramen_soba.mat','CODEBOOK');
   y = list;
end