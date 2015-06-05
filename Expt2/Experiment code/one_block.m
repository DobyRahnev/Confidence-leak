function p = one_block(window, width, height, number_trials, p)

square = p.squareSizeInPixels;
p.number_incorrect = 0;

%Start the sequence of trials
for i=1:number_trials
    
    trial = p.current_trial;
    p.current_trial = p.current_trial + 1;
    
    p.color_diff(p.run,trial) = ceil(2*rand); %1: difficult, 2: easy
    p.xo_diff(p.run,trial) = ceil(2*rand); %1: difficult, 2: easy
    
    if p.red{p.run}(trial) == 1
        number_reds = p.red_values(p.color_diff(p.run,trial));
    else
        number_reds = 40 - p.red_values(p.color_diff(p.run,trial));
    end
    
    if p.x_es{p.run}(trial) == 1
        number_x_es = p.xo_values(p.xo_diff(p.run,trial));
    else
        number_x_es = 40 - p.xo_values(p.xo_diff(p.run,trial));
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
    WaitSecs(p.stim_duration);
    
    %Present the 2 questions
    if p.task1_is_color
        correct_answer1 = (number_reds < 20) + 1; %1:red, 2:blue
        correct_answer2 = (number_x_es < 20) + 1; %1:X, 2:O
    else
        correct_answer1 = (number_x_es < 20) + 1; %1:X, 2:O
        correct_answer2 = (number_reds < 20) + 1; %1:red, 2:blue
    end
    
    if p.task1_is_scale %Scale and then opt out
        [answer1 conf1 correct1 rt1 rt3 p] = scale_question(window, width, height, p.task1_is_color, correct_answer1, p, time);
        [answer2 conf2 correct2 rt2 p] = optOut_question(window, width, height, 1-p.task1_is_color, correct_answer2, p, time);
    else %Opt out, then scale
        [answer1 conf1 correct1 rt1 p] = optOut_question(window, width, height, p.task1_is_color, correct_answer1, p, time);
        [answer2 conf2 correct2 rt2 rt3 p] = scale_question(window, width, height, 1-p.task1_is_color, correct_answer2, p, time);
    end
    
    %Give a 300ms of a blank screeen before the next trial
    Screen('Flip', window);
    WaitSecs(.3);
    
    p.answers(p.run,trial,:) = [answer1 conf1 correct1 answer2 conf2 correct2];
    p.rt(p.run,trial,:) = [rt1 rt2 rt3];
    
end