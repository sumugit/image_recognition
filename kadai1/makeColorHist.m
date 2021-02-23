%カラーヒストグラム作成
function training = makeColorHist
    %画像pathのリスト作成
    n=0; list={};
    database=[];
    %食事画像の入ったフォルダ(組み合わせ変更時に修正必須)
    LIST={'img_ramen' 'bgimg'};
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
                list={list{:} fn};
                %取り出す画像枚数(組み合わせ変更時に修正必須)
                if n == 300
                    break;
                end
            end
        end
    end
    %カラーヒストグラム作成
    for i=1:size(list,2)
        %アスペクト比を保持したまま縮小
        X=imresize(imread(list{i}), [320 NaN]);
        RED=X(:,:,1); GREEN=X(:,:,2); BLUE=X(:,:,3);
        X64=floor(double(RED)/64) *4*4 + floor(double(GREEN)/64) *4 + floor(double(BLUE)/64);
        X64=reshape(X64,1,numel(X64));
        h=histc(X64,[0:63]);
        %要素の合計が１になるように正規化
        h = h / sum(h);
        database=[database; h];
    end
    %db保存(組み合わせ変更時に修正必須)
    save('db_ramen_bgimg.mat', 'database');
    training = list;
end