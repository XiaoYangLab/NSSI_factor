classdef begining < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        UITable         matlab.ui.control.Table
        SubmitButton    matlab.ui.control.Button
    end

    properties (Access = public)
        SurveyResults = NaN(1,29); % Use NaN to initialize, to distinguish unanswered from choosing 0
        % Important: Update the number if questions are added or removed (e.g., NaN(1,29) for 29 questions)
        QuestionsAnswered = false(1,29); % Track whether each question has been answered
        % Important: Update the number if questions are added or removed (e.g., false(1,29) for 29 questions)
    end

    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 770 700];
            app.UIFigure.Name = 'Self-Injury Survey';

            % Create Instruction Text
            InstructionText = uilabel(app.UIFigure);
            InstructionText.Position = [20 630 745 80];
            InstructionText.Text = ['What was the reason you first started self-injuring (not as a suicide attempt)? '  ...
                                     'Below are some possible reasons — please check the ones that apply to you.'];
            InstructionText.FontSize = 15;
            InstructionText.FontWeight = 'bold';
            InstructionText.WordWrap = 'on';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Question', 'Never', 'Rarely', 'Sometimes', 'Often', 'Always'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = [false true true true true true];
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Multiselect = 'on';
            app.UITable.Position = [20 100 735 550];
            app.UITable.FontSize = 14;

            % Create Submit Button
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.Position = [350 30 100 40];
            app.SubmitButton.Text = 'Submit';
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
        '1. To release unbearable tension';
        '2. To experience a “high” like a drug high';
        '3. To stop my parents from being angry at me';
        '4. To stop feeling alone and empty';
        '5. To get care and attention from other people';
        '6. To punish myself';
        '7. To provide a sense of excitement that feels exhilarating';
        '8. To relleve nervousness/fearfuiness';
        '9. To avoid getting in trouble for something I did';
        '10. To distract me from unpleasant memories';
        '11. To change my body image and/or appearance';
        '12. To belong to a group';
        '13. To release anger';
        '14. To stop my friends/boyfriend/girlfriend from being anger at me';
        '15. To show others how hurt or damaged I am';
        '16. To show others how strong or though I am';
        '17. To help me escape from uncomfortable feelings or moods';
        '18. To satisty voices inside or outside of me telling me to do it';
        '19. To experience physical pain in one area, when the other pain I feel is unbearable苦';
        '20. To stop people from expecting so much from me';
        '21. To relieve feelings of sadness or feeling ''down''';
        '22. To have control in a situation where no one can influence me';
        '23. To stop me from thinking about ideas of killing myself';
        '24. To stop me from acting out ideas to kill myself';
        '25. To produce a sense of being real when I feel numb and ``unreal''';
        '26. To release frustration';
        '27. To get out of doing something that I don not want to do';
        '28. For no reason that I know about - it just happens sometimes';
        '29. To prove to myself how much I can take';
                };

            % Create the table data with questions and empty options
            data = [questions, repmat({false}, 29, 5)]; % Important: Adjust column size if question number changes

            % Set the table data
            app.UITable.Data = data;

            % Adjust column widths
            app.UITable.ColumnWidth = {350, 'auto', 'auto', 'auto', 'auto', 'auto'};
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;

            % Ensure only response columns (2-6) are processed
            if indices(2) >= 2 && indices(2) <= 6
                row = indices(1);  % Question index
                col = indices(2);  % Option column

                % Reset all options in the current row to false (single choice)
                for i = 2:6
                    app.UITable.Data{row, i} = false;
                end

                % Set selected option to true
                app.UITable.Data{row, col} = true;

                % Update response matrix (column index minus 2 gives value 0–4)
                app.SurveyResults(row) = col - 2;
                app.QuestionsAnswered(row) = true; % Mark as answered

                % Refresh table display
                app.UITable.Data = app.UITable.Data;
            end
        end

        % Submit button callback
        function SubmitButtonPushed(app, event)
            % Check for unanswered questions using QuestionsAnswered
            unanswered = find(~app.QuestionsAnswered);

            if ~isempty(unanswered)
                % Build warning message for unanswered items
                if length(unanswered) > 5
                    msg = sprintf('Please answer all questions before submitting!\n\nUnanswered items: %s and %d more', ...
                        mat2str(unanswered(1:5)), length(unanswered));
                else
                    msg = sprintf('Please answer all questions before submitting!\n\nUnanswered items: %s', ...
                        mat2str(unanswered));
                end

                uialert(app.UIFigure, msg, 'Incomplete Survey', 'Icon', 'warning');
                return;
            end

            % Resume app (e.g., to allow saving results externally)
            uiresume(app.UIFigure);
            % You can add saving logic here, e.g.:
            % save('survey_results.mat', 'app.SurveyResults');
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = begining
            createComponents(app)
            registerApp(app, app.UIFigure)
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            delete(app.UIFigure)
        end
    end
end
