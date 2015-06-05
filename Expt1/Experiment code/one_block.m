function p = one_block(window, width, height, number_trials, p)

one = KbName('1!');
two = KbName('2@');
three = KbName('3#');
four = KbName('4$');
nine = KbName('9(');

square = p.squareSizeInPixels;
p.number_incorrect = 0;

%%WaitSecs(.5);

for i=1:number_trials
    
    trial = p.current_trial;
    p.current_trial = p.current_trial + 1;
    
    if p.red{p.run}(trial) == 1
        number_reds = p.red_run(p.run);
    else
        number_reds = 40 - p.red_run(p.run);
    end
    
    if p.x_es{p.run}(trial) == 1
        number_x_es = p.xes_run(p.run);
    else
        number_x_es = 40 - p.xes_run(p.run);
    end
    
    
    red = randperm(40);
    x_o = randperm(40);
    
    for symbols=1:40
        if red(symbols) <= number_reds
            color = [255 0 0];
        else
            color = [0 0 255];
        end
        
        if x_o(symbols) <= number_x_es
            symbol = 'X';
            symbol_code = 1;
        else
            symbol = 'O';
            symbol_code = 0;
        end
        
        p.symbol(p.run,trial,symbols,:) = [rand, rand, symbol_code, color];
        DrawFormattedText(window, symbol, width/2 + (p.symbol(p.run,trial,symbols,1)-.5)*square, ...
            height/2 + (p.symbol(p.run,trial,symbols,2)-.5)*square, color);
    end
    time = Screen('Flip', window);
        
    %Display question
    DrawFormattedText(window, 'Were there more X''s or O''s?', 'center', height-400, 255);
    DrawFormattedText(window, '1: More X''s', 'center', height-350, 255);
    DrawFormattedText(window, '2: More O''s', 'center', height-320, 255);
    Screen('Flip', window, time + p.stim_duration);
    
    %Collect response
    while 1
        [keyIsDown,secs,keyCode]=KbCheck;
        if keyIsDown
            if keyCode(one)
                answer1 = 1;
                break;
            elseif keyCode(two)
                answer1 = 2;
                break;
            elseif keyCode(nine)
                answer = bbb; %forcefully break out
            end
        end
    end
    rt1 = secs - time;
    
    %Display question
    DrawFormattedText(window, 'How confident are you?', 'center', height-400, 255);
    DrawFormattedText(window, '1: Not confident at all', 'center', height-350, 255);
    DrawFormattedText(window, '2: Slightly confident', 'center', height-320, 255);
    DrawFormattedText(window, '3: Quite confident', 'center', height-290, 255);
    DrawFormattedText(window, '4: Very confident', 'center', height-260, 255);
    Screen('Flip', window);
       
    %Wait 300 ms to prevent double-reading of the first key press
    WaitSecs(.3);
    
    %Collect response
    while 1
        [keyIsDown,secs,keyCode]=KbCheck;
        if keyIsDown
            if keyCode(one)
                conf1 = 1;
                break;
            elseif keyCode(two)
                conf1 = 2;
                break;
            elseif keyCode(three)
                conf1 = 3;
                break;
            elseif keyCode(four)
                conf1 = 4;
                break;
            elseif keyCode(nine)
                conf = bbb; %forcefully break out
            end
        end
    end
    rt2 = secs - time;
    
    %compute if answer is correct
    if (number_x_es > 20) == (answer1 == 1)
        correct1 = 1;
    else
        correct1 = 0;
        p.number_incorrect = p.number_incorrect + 1;
    end
    
    %Give feedback, if needed        
    if p.feedback == 1
        if correct1
            DrawFormattedText (window, 'CORRECT', 'center', 'center', [0 255 0]);
        else
            DrawFormattedText (window, 'WRONG', 'center', 'center', [255 0 0]);
        end
        Screen('Flip', window);
    end
    WaitSecs(.3);
    
    %Display second question
    DrawFormattedText(window, 'Were there more red or blue letters?', 'center', height-400, 255);
    DrawFormattedText(window, '1: More red', 'center', height-350, 255);
    DrawFormattedText(window, '2: More blue', 'center', height-320, 255);
    Screen('Flip', window);
    
    %Wait 300 ms to prevent double-reading of the first key press
    if p.feedback ~= 1
        WaitSecs(.3);
    end
    
    %Collect response
    while 1
        [keyIsDown,secs,keyCode]=KbCheck;
        if keyIsDown
            if keyCode(one)
                answer2 = 1;
                break;
            elseif keyCode(two)
                answer2 = 2;
                break;
            elseif keyCode(nine)
                answer = bbb; %forcefully break out
            end
        end
    end
    rt3 = secs - time;
    
    %Display question
    DrawFormattedText(window, 'How confident are you?', 'center', height-400, 255);
    DrawFormattedText(window, '1: Not confident at all', 'center', height-350, 255);
    DrawFormattedText(window, '2: Slightly confident', 'center', height-320, 255);
    DrawFormattedText(window, '3: Quite confident', 'center', height-290, 255);
    DrawFormattedText(window, '4: Very confident', 'center', height-260, 255);
    Screen('Flip', window);
    
    %Wait 300 ms to prevent double-reading of the first key press
    WaitSecs(.3);
    
    %Collect response
    while 1
        [keyIsDown,secs,keyCode]=KbCheck;
        if keyIsDown
            if keyCode(one)
                conf2 = 1;
                break;
            elseif keyCode(two)
                conf2 = 2;
                break;
            elseif keyCode(three)
                conf2 = 3;
                break;
            elseif keyCode(four)
                conf2 = 4;
                break;
            elseif keyCode(nine)
                conf = bbb; %forcefully break out
            end
        end
    end
    rt4 = secs - time;
    
    %compute if answer is correct
    if (number_reds > 20) == (answer2 == 1)
        correct2 = 1;
    else
        correct2 = 0;
        p.number_incorrect = p.number_incorrect + 1;
    end
    
    %Give feedback, if needed        
    if p.feedback == 1
        if correct2
            DrawFormattedText (window, 'CORRECT', 'center', 'center', [0 255 0]);
        else
            DrawFormattedText (window, 'WRONG', 'center', 'center', [255 0 0]);
        end
    end
    Screen('Flip', window);
    WaitSecs(.3);
    
    p.answers(p.run,trial,:) = [answer1 conf1 correct1 answer2 conf2 correct2];
    p.rt(p.run,trial,:) = [rt1 rt2 rt3 rt4];
    
end