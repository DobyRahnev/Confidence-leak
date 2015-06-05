function [answer conf correct rt1 rt2 p] = scale_question(window, width, height, color_task, correct_answer, p, time)

if color_task
    text1 = 'More red letters';
    text2 = 'More blue letters';
else
    text1 = 'More X''s';
    text2 = 'More O''s';    
end

%Display the question and allow subjects to move the cursor
DrawFormattedText(window, 'There were ... (click on your answer)', 'center', height-400, 255);
Screen('TextSize',window, 50);
[nx1, ny2, textbounds{1}] = DrawFormattedText(window, text1, 'center', height-350, 255);
[nx1, ny2, textbounds{2}] = DrawFormattedText(window, text2, 'center', height-250, 255);
Screen('TextSize',window, 30);
Screen('FrameRect', window, 255, textbounds{1}, 2);
Screen('FrameRect', window, 255, textbounds{2}, 2);
Screen('Flip', window);

% Display and set cursor
import java.awt.Robot;
mouse = Robot;
ShowCursor;
mouse.mouseMove(width/2, -20 + (textbounds{1}(4) + textbounds{2}(4))/2);

%Collect the response
GetClicks(0,.00000001);
rt1 = GetSecs - time;
PointerLocation = get(0, 'PointerLocation');
if PointerLocation(2) > height - (textbounds{1}(4) + textbounds{2}(4))/2
    answer = 1;
    color1 = [255 0 0];
    color2 = 255;
else
    answer = 2;
    color1 = 255;
    color2 = [255 0 0];
end

%Display the question and allow subjects to move the cursor
DrawFormattedText(window, 'There were ... (click on your answer)', 'center', height-400, 255);
Screen('TextSize',window, 50);
DrawFormattedText(window, text1, 'center', height-350, 255);
DrawFormattedText(window, text2, 'center', height-250, 255);
Screen('TextSize',window, 30);
Screen('FrameRect', window, color1, textbounds{1}, 2);
Screen('FrameRect', window, color2, textbounds{2}, 2);
Screen('Flip', window);
WaitSecs(.2);


%Get confidence on a continuous scale!

% Display and set cursor
mouse.mouseMove(width/2, height - 400);

%Display the question and allow subjects to move the cursor
DrawFormattedText(window, 'How confident are you?', 'center', height-600, 255);
DrawFormattedText(window, 'Not confident at all                                     Very confident', 'center', height-350, 255);
Screen('DrawLine', window, 255, width/2-300, height-400, width/2+300, height-400, 5); %change back to 20
Screen('Flip', window);
GetClicks(0,.00000001);
rt2 = GetSecs - time;

%Collect the response
PointerLocation = get(0, 'PointerLocation');
if PointerLocation(1) > width/2+300
    conf_scale = width/2+300;
elseif PointerLocation(1) < width/2-300
    conf_scale = width/2-300;
else
    conf_scale = PointerLocation(1);
end
conf = (conf_scale - (width/2-300)) / 600;
HideCursor;

%Display the answer
DrawFormattedText(window, 'How confident are you?', 'center', height-600, 255);
DrawFormattedText(window, 'Not confident at all                                     Very confident', 'center', height-350, 255);
Screen('DrawLine', window, 255, width/2-300, height-400, width/2+300, height-400, 5); %change back to 20
Screen('FillOval', window, [255 0 0], [conf_scale-20, height-400-20, conf_scale+20, height-400+20]);
Screen('Flip', window);
WaitSecs(.2);

%compute if answer is correct
if correct_answer == answer
    correct = 1;
    p.total_points = p.total_points + 4;
else
    correct = 0;
    p.number_incorrect = p.number_incorrect + 1;
    p.total_points = p.total_points - 1;
end

%Give feedback, if needed
if p.feedback == 1
    if correct
        DrawFormattedText (window, 'CORRECT (+4 points)', 'center', 'center', [0 255 0]);
    else
        DrawFormattedText (window, 'WRONG (-1 point)', 'center', 'center', [255 0 0]);
    end
    Screen('Flip', window);
    WaitSecs(.5);
end