%开始界面
app_begin = appbegin1();
uiwait(app_begin.UIFigure);   %等待完成调查
% 确认是否完成
  begin = app_begin.begin;
      delete(app_begin); 
  if begin
    % 自动关闭App
    
        question1 = begining();
        uiwait(question1.UIFigure);   %等待完成调查
        x1 = question1.SurveyResults;     %获取的最初数据
        delete(question1);

        question2 = month();
        uiwait(question2.UIFigure);   %等待完成调查
        x2 = question2.SurveyResults;    %获取的当前（一个月内的）数据
        delete(question2);


        


            newX1 = x1(:, 1:29);    %取前29列作为新矩阵(可根据实际情况调节)
            newX2 = x2(:, 1:29);    %取前29列作为新矩阵(可根据实际情况调节)

            disp(newX1);
            disp(newX2);

            nssi = sum(newX1);
            nssimonth = sum(newX2);
            disp('Total score of NSSI at initial times:'); disp(nssi);
            disp('Total score of NSSI last month:'); disp(nssimonth);
            
            social = newX1(1,1)+newX1(1,2)+newX1(1,4)+newX1(1,6)+newX1(1,7)+newX1(1,8)+newX1(1,10)+newX1(1,17)+newX1(1,18)+newX1(1,19)+newX1(1,21)+newX1(1,23)+newX1(1,24)+newX1(1,25)+newX1(1,28);
            individual = nssi-social;
            disp('Social score of NSSI at initial times:');disp(social);
            disp('Social score of NSSI last month:');disp(individual);


            socialmonth = newX2(1,1)+newX2(1,2)+newX2(1,4)+newX2(1,6)+newX2(1,7)+newX2(1,8)+newX2(1,10)+newX2(1,17)+newX2(1,18)+newX2(1,19)+newX2(1,21)+newX2(1,23)+newX2(1,24)+newX2(1,25)+newX2(1,28);
            individualmonth = nssimonth-socialmonth;
            disp('Self score of NSSI at initial times:');disp(socialmonth);
            disp('Self score of NSSI last month:');disp(individualmonth);

            % 进行额外计算
            h = [9.29164666619657	6.35329505854942	2.21429542569857	6.02274060971425	3.73206250311608	7.88861329942243	5.85312368945322	7.68972249433206	2.82605611725957	7.44094245606748	1.59866823601727	1.23569703117713	6.86291259475448	1.48253857777259	2.51617358295329	1.24758916884819	9.31842945716018	5.49978679391522	8.43750136171128	3.54096912945688	9.19094477503637	4.60077374510049	5.84068582493331	5.77339819618864	7.85237250512991	6.44413320497234	3.27718107878653	6.03231330323960	2.18885743744455;
                7.19289780147951	5.12195159218667	4.60894609668354	5.98559825896727	6.31440894119750	7.15357484874058	4.71718750845377	6.45334165450706	5.06904271443415	6.47625154681361	2.52689850482457	2.36945020249336	6.87331701420345	3.15407015193002	6.69946558721825	1.95006020292135	7.33775536096607	4.90593291900245	6.96546962282806	5.40599784911057	7.48288703780147	5.59441164636823	3.86083469790920	3.85740212180548	6.53759674843721	7.13759769696686	6.01856327219705	5.33654364353376	3.18603860948265];
            w1 = newX1 / h;
            w2 = newX2 / h;
            disp('w1:'); disp(w1);
            disp('w2:'); disp(w2);

    % 定义三个中心点
    centers = [0.00641040188316210, 0.0819724016038253;  % 社会center1
               0.0674271611089854, 0.00487890789075190;  % 个人center2
               0.0328250279507096, 0.0377512862620591];  % 未分化center3

    
    % 计算w1到各中心点的欧式距离
    dist_w1 = sqrt(sum((w1 - centers).^2, 2));
    [min_dist_w1, idx_w1] = min(dist_w1);
    
    % 计算w2到各中心点的欧式距离
    dist_w2 = sqrt(sum((w2 - centers).^2, 2));
    [min_dist_w2, idx_w2] = min(dist_w2);

    %显示结果
    disp('The distance from w1 to each center point:'); disp(dist_w1');
    disp('w1 nearest center:'); disp(idx_w1);
    disp('The minimum distance:'); disp(min_dist_w1);

    disp('The distance from w2 to each center point:'); disp(dist_w2');
    disp('w2 nearest center:'); disp(idx_w2);
    disp('The minimum distance:'); disp(min_dist_w2);
    
    % 根据最近的center输出结果
    center_names = {'Self-subtype', 'Social-subtype', 'Non-specific subtype'};

    % fprintf('w1 属于 %s (距离: %.4f)\n', center_names{idx_w1}, min_dist_w1);
    % fprintf('w2 属于 %s (距离: %.4f)\n', center_names{idx_w2}, min_dist_w2);

window1 = msgbox(...
    sprintf('There is an 80%% chance that your initial self-harm was caused by %s. \nThere is an 80%% chance that your self-harm in the past month was caused by %s. \nInitial NSSI total score %d, NSSI total score within one month: %d. \nInitial social function total score: %d, Initial self-function total score: %d. \nCurrent social function total score: %d, Current self-function total score: %d', center_names{idx_w1}, center_names{idx_w2},nssi, nssimonth,social, individual,socialmonth, individualmonth), ...
    'complete', ...
    'help' ... % 使用帮助图标
);


% window2 = msgbox(...
%     sprintf('测试结束，你近一个月的自伤原因有80%%的可能来源于 %s', center_names{idx_w2}), ...
%     '完成', ...
%     'help' ... % 使用帮助图标
% );

    % 设置新尺寸 (宽度300px, 高度150px)
    % newPos = [300, 300, 500, 200]; % [x, y, width, height]
    % set(window1, 'Position', newPos);
    % set(window2, 'Position', newPos);
    
    % 锁定尺寸并居中
    % set(window1, 'Resize', 'off');
    % set(window2, 'Resize', 'off');
    % movegui(window1, 'center'); % 窗口屏幕居中
    % movegui(window2, 'center'); % 窗口屏幕居中
    
    % 修改字体大小（可选）
    % txtObj1 = findobj(window1, 'Type', 'Text');
    % set(txtObj1, 'FontSize', 11);
    % 
    % txtObj2 = findobj(window2, 'Type', 'Text');
    % set(txtObj2, 'FontSize', 11);
    % uialert('测试结束，你的自伤原因有80%的可能来源于%s', center_names{idx_w1}, '完成');
    % uialert('测试结束，你的自伤原因有80%的可能来源于%s', center_names{idx_w2}, '完成');
    
        else
            warning('用户取消了问卷');
  end
  clear app1;
  clear app_begin;
    
    






        