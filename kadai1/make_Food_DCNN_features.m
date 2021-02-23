function [DCNNdata, imgList] = make_Food_DCNN_features
    %画像pathのリスト作成
    n=0; list={};
    %DCNN特徴の抽出
    training_data = []; 
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
    for i = 1:size(list, 2)
        disp(size(training_data));
        % network, 入力画像を準備します．
        net = alexnet;
        %net = densenet201;
        %net = vgg16;
        img = imread(list{i});
        reimg = imresize(img,net.Layers(1).InputSize(1:2)); 
        % activationsを利用して中間特徴量を取り出します．
        % 4096次元の'fc8'から特徴抽出します．
        dcnnf = activations(net,reimg,'fc7');
        % squeeze関数で，ベクトル化します．
        dcnnf = squeeze(dcnnf);
        % L2ノルムで割って，L2正規化．
        % 最終的な dcnnf を画像特徴量として利用します．
        dcnnf = dcnnf/norm(dcnnf);
        %転置してpush
        training_data = [training_data; dcnnf.'];
    end
    DCNNdata = training_data;
    imgList = list;
end