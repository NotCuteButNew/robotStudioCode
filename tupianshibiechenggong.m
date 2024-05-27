% 创建TCP/IP服务器
t = tcpip('0.0.0.0', 60000, 'NetworkRole', 'server');
set(t, 'OutputBufferSize', 1024);

% 等待客户端连接
fopen(t);
disp('等待客户端连接...');

while true
    % 接收来自客户端的消息
    if t.BytesAvailable > 0
        receivedMsg = fread(t, t.BytesAvailable, 'char');
        receivedMsg = char(receivedMsg');
        
        % 当收到 'pz' 时，开始识别图片并发送结果
        if strcmp(receivedMsg, 'pz')
            disp('接收到 "pz"，开始识别图片...');
            
            % 定义文件夹路径
            imageDir = 'C:\Users\Lenovo\Desktop\1';
            fileList = dir(fullfile(imageDir, '*.jpg')); % 仅限 jpg 格式的图片

            % 遍历每张图片
            for i = 1:numel(fileList)
                img = imread(fullfile(imageDir, fileList(i).name)); % 读取图片

                % 分离红、绿、蓝通道
                redChannel = img(:, :, 1);
                greenChannel = img(:, :, 2);
                blueChannel = img(:, :, 3);

                % 进行颜色识别
                redFraction = sum(redChannel(:) > 100) / numel(redChannel);
                if redFraction > 0.5
                    color = 'hong';
                elseif sum(greenChannel(:) > 100) / numel(greenChannel) > 0.5
                    color = 'lu';
                elseif sum(blueChannel(:) > 100) / numel(blueChannel) > 0.5
                    color = 'lan';
                else
                    color = 'buzhi';
                end

                % 显示颜色信息
                disp(['图片' num2str(i) ' 的颜色是：' color]);

                % 将颜色信息发送到客户端
                fwrite(t, color);
            end
        end
    end
end

% 关闭连接
fclose(t);
