%% caculate all vertexes' position including latent & observable (31 node) (first vertex using the center of labels)
%
%  call function: imgPreprocess(),depthrevise()
%
%  Function: This .m file is used for caculating All vertex's location for training images by using a fixed structure  LTM(generated by geodesic distance)
%
%  Input:  @curImgIndex: current image set index
%             @labels: All images labels - 16 points position
%             @LTM : LTM model
%             @imageNames：all image name
%
%  Output: @allVertexpos：current image set's all vertex position
%
%  written by Sophia
%  last modified date : 2016.01.12
%%

function [allVertexpos] = Copy_of_caculateAllVertexes(curimgIndex,labels,imageNames,LTM,img_path)

disp('## Caculating Vertexpos. . . . . . ');

vertexNum = 31;
imageNum = size(curimgIndex,1);        %image num
allVertexpos = zeros(imageNum,vertexNum*3);  %save all vertexes' position,e.g.[(x,y,z),(x,y,z),...,]
latTree = zeros(size(LTM,1),16);       %every LTM vertex(observable & latent) include the observable vertexes（0-include，1-not include)

%building a 0-1 matrix of LTM to caculate all vertex position ( including latent vertex）
for i=1:size(LTM,1);
    latTree(i,uint16(LTM{i,1}(5:end))) = 1;
end
avg =  repmat(sum(latTree'),imageNum,1); % the numeber of  labels in each vertex of LTM

%caculate all vertex position(x,y,z)
allVertexpos(:,1:3:vertexNum*3) = (labels(curimgIndex,1:3:end)*latTree')./avg;  % x
allVertexpos(:,2:3:vertexNum*3) = (labels(curimgIndex,2:3:end)*latTree')./avg;  % y

%%caculate the each vertex depth
for t = 1:size(imageNames,1)
     [originx,originy,origind,I] = imgPreprocess([img_path,imageNames{t,1}],30000);
%     %取到背景深度
%         if(origind > 30000)            
%             row = ceil(originy);
%             col = ceil(originx);
%             %取该点领域为r的像素值最小的像素值
%             [x, y, d] = depthrevise(I,row,col,origind);         
%             allVertexpos(t,1) = x;
%             allVertexpos(t,2) = y;
%             allVertexpos(t,3) = d;
%         else
%             allVertexpos(t,1) = originx;
%             allVertexpos(t,2) = originy;
%             allVertexpos(t,3) = origind;
%         end
%
%     %plot
    imshow(mat2gray(I));
    hold on;
    plot(originx,originy,'r*');
    for tt = 1:16
        plot(labels(t,tt*3-2),labels(t,tt*3-1),'go');
    end
%     %plot
    
    plot(allVertexpos(t,1),allVertexpos(t,2),'b*');
    for j = 2:31
        allVertexpos(t,j*3) = I(ceil(allVertexpos(t,j*3-1)),ceil(allVertexpos(t,j*3-2)));
%         disp(['x = ',num2str(allVertexpos(t,j*3-2)),',y = ',num2str(allVertexpos(t,j*3-1)),',depth = ',num2str(allVertexpos(t,j*3))]);
        plot(allVertexpos(t,j*3-2),allVertexpos(t,j*3-1),'r.');
    end
     
%% debug
%     if(t >= 17500)
%     imshow(mat2gray(aftimg));
%     hold on;
%     plot(originx,originy,'r*');
%     title(imageNames{t,1});
%     pause(0.1);
%     end
%%

end
end

