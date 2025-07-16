classdef month < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        UITable         matlab.ui.control.Table
        SubmitButton    matlab.ui.control.Button
    end
    
    properties (Access = public)
        SurveyResults = NaN(1,30); % 改为用NaN初始化，区分未回答和选择0的情况
        QuestionsAnswered = false(1,30); % 新增：跟踪问题是否已回答
    end
    
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 770 700];
            app.UIFigure.Name = '调查问卷';
            
            % Create Instruction Text
            InstructionText = uilabel(app.UIFigure);
            InstructionText.Position = [20 630 745 80];
            InstructionText.Text = ['如果你当前（指过去 1 个月内）仍有自伤（不是想自杀的伤害）行为，那你当前自伤的理由是什么？'  ...
                                      '下面列了一些可能的原因，请根据你自身的实际情况在相应的选项上打钩。'];
            InstructionText.FontSize = 15;
            InstructionText.FontWeight = 'bold';
            InstructionText.WordWrap = 'on';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            
            app.UITable.ColumnName = {'问题内容', '从不', '偶尔', '有时', '经常', '总是'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = [false true true true true true];
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Multiselect = 'on';
            app.UITable.Position = [20 100 735 550];
            app.UITable.FontSize = 14;
            
            % Create Submit Button
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.Position = [350 30 100 40];
            app.SubmitButton.Text = '提交问卷';
            app.SubmitButton.ButtonPushedFcn = createCallbackFcn(app, @SubmitButtonPushed, true);
            app.SubmitButton.FontSize = 14;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
    
    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Initialize the table data with survey questions
            questions = {
        '1. 释放无法承受的压力';
        '2. 体验“快感”';
        '3. 令父母不再生我的气';
        '4. 摆脱孤独与空虚感';
        '5. 获得他人的关心与关注';
        '6. 惩罚自己';
        '7. 体验令人愉悦的刺激';
        '8. 释放紧张感或恐惧感';
        '9. 避免因自己所做的事而陷入麻烦';
        '10. 将注意力从不愉快的记忆中转移';
        '11. 改变自我形象或外表';
        '12. 感觉被某些同龄伙伴接受';
        '13. 释放愤怒';
        '14. 让我的朋友或男友或女友停止对我生气';
        '15. 向他人表明自己很受伤';
        '16. 向他人展示我有多强大';
        '17. 让自己摆脱不舒服的情绪';
        '18. 遵循自己内在的想法或他人的建议而施行自伤';
        '19. 体验身体局部疼痛，以此转移自己无法承受的其他痛苦';
        '20. 摆脱别人对自己过高的期望';
        '21. 释放悲伤和消极情绪';
        '22. 想在一个没人可以影响自己的方面获得掌控感';
        '23. 阻止自己施行自杀的想法';
        '24. 防止自己施行自杀';
        '25. 当感到麻木和“非真实感”时,通过自伤行为感受到真实感';
        '26. 释放挫折感';
        '27. 摆脱自己不想做的事情';
        '28. 感觉没有原因，就是有时会自伤';
        '29. 验证自己的承受力';
        '30. “沉迷”于自伤行为';
                };
            
            % Create the table data with questions and empty options
            data = [questions, repmat({false}, 30, 5)];
            
            % Set the table data
            app.UITable.Data = data;
            
            % Adjust column widths
            app.UITable.ColumnWidth = {350, 'auto', 'auto', 'auto', 'auto', 'auto'};
            
            % Initialize survey results
            app.SurveyResults = NaN(1,30); % 使用NaN表示未回答
            app.QuestionsAnswered = false(1,30); % 初始化回答状态
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            
            % 确保只处理选项列(2-6列)
            if indices(2) >= 2 && indices(2) <= 6
                row = indices(1);  % 问题编号
                col = indices(2);  % 选项列
                
                % 将当前行的所有选项设为false(实现单选)
                app.UITable.Data{row, 2} = false;
                app.UITable.Data{row, 3} = false;
                app.UITable.Data{row, 4} = false;
                app.UITable.Data{row, 5} = false;
                app.UITable.Data{row, 6} = false;
                
                % 设置选中的选项为true
                app.UITable.Data{row, col} = true;
                
                % 更新结果矩阵(列号-2得到分值0-4)
                app.SurveyResults(row) = col-2;
                app.QuestionsAnswered(row) = true; % 标记为已回答
                
                % 刷新表格显示
                app.UITable.Data = app.UITable.Data;
            end
        end
        
        % Submit button callback
        function SubmitButtonPushed(app, event)
            % 检查未回答的问题(现在使用QuestionsAnswered判断)
            unanswered = find(~app.QuestionsAnswered);
            
            if ~isempty(unanswered)
                % 构建未回答问题列表信息
                if length(unanswered) > 5
                    msg = sprintf('请回答所有问题后再提交！\n\n未回答问题: %s 等共%d题', ...
                        mat2str(unanswered(1:5)), length(unanswered));
                else
                    msg = sprintf('请回答所有问题后再提交！\n\n未回答问题: %s', ...
                        mat2str(unanswered));
                end
                
                uialert(app.UIFigure, msg, '未完成问卷', 'Icon', 'warning');
                
                return;
            end

            
            % % 显示结果(实际应用中可替换为保存到文件等操作)
            % msg = sprintf('问卷提交成功！\n结果矩阵为:\n%s', mat2str(app.SurveyResults));
            % uialert(app.UIFigure, msg, '提交成功', 'Icon', 'success');
                        uiresume(app.UIFigure); % 解除等待状态（关键！）
            % 这里可以添加保存结果的代码，例如：
            % save('survey_results.mat', 'app.SurveyResults');
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = month
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end