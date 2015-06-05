function [answer conf correct rt p] = optOut_question(window, width, height, color_task, correct_answer, p, time)

one = KbName('1!');
two = KbName('2@');
three = KbName('3#');

if color_task
    question = 'Were there more red or blue letters?';
    text1 = '2: More red';
    text2 = '3: More blue';
else
    question = 'Were there more X''s or O''s?';
    text1 = '2: More X''s';
    text2 = '3: More O''s';
end

%Display the question
DrawFormattedText(window, question, 'center', height-400, 255);
DrawFormattedText(window, '1: Opt out', 'center', height-350, 255);
DrawFormattedText(window, text1, 'center', height-320, 255);
DrawFormattedText(window, text2, 'center', height-290, 255);
Screen('Flip', window);

%Collect response
while 1
    [keyIsDown,secs,keyCode]=KbCheck;
    if keyIsDown
        if keyCode(one)
            answer = 9;
            conf = 1;
            break;
        elseif keyCode(two)
            answer = 1;
            conf = 2;
            break;
        elseif keyCode(three)
            answer = 2;
            conf = 2;
            break;
        end
    end
end
rt = secs - time;

%compute if answer is correct
if answer == 9
    correct = 9;
    p.total_points = p.total_points + 2;
elseif correct_answer == answer
    correct = 1;
    p.total_points = p.total_points + 4;
else
    correct = 0;
    p.number_incorrect = p.number_incorrect + 1;
    p.total_points = p.total_points - 1;
end

%Give feedback, if needed
if p.feedback == 1
    if answer == 9
        DrawFormattedText (window, 'OPT OUT (+2 points)', 'center', 'center', [255,255,0]);
    elseif correct
        DrawFormattedText (window, 'CORRECT (+4 points)', 'center', 'center', [0 255 0]);
    else
        DrawFormattedText (window, 'WRONG (-1 point)', 'center', 'center', [255 0 0]);
    end
    Screen('Flip', window);
    WaitSecs(.5);
end
