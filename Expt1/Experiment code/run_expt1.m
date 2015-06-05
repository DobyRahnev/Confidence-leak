% run_expt1

try

    clear
    
    %Open window and do useful stuff
    [window,width,height] = openScreen();

    Screen('TextFont',window, 'Arial');
    Screen('TextSize',window, 30);
    Screen('FillRect', window, 127);
    p.wrapat = 80;
    
    
    %detect keyboard
    if IsOSX
        p.keyboard = getKeyboardNumber;
    else
        p.keyboard = 0;
    end
    
    % stimulus sizes
    monitorDistance = 60; %in cm
    squareSizeInDegrees = 10;
    p.squareSizeInPixels = degrees2pixels(squareSizeInDegrees, monitorDistance);
    p.run = 1;
    p.current_trial = 1;
    p.feedback = 1;
    
    %initial_instructions(window, width, height, p);
    
    p.feedback = 0;
    
    % Define the parameters of the experiment
    p = defineParameters(p);
    
   
    %% Instructions
    text = 'Very good. We are now ready to begin the actual experiment. It will look very similar to the last training block that you just completed. The difficulty of each of the two tasks may change from block to block or from trial to trial.\n\nYou will have 4 runs of 4 blocks each. You will have 15 seconds of rest after each block and will be able to take as much rest as you need between runs.\n\nPress any key to continue.';
    DrawFormattedText(window, text, 300, 'center', 255, p.wrapat);
    Screen('Flip',window);
    WaitSecs(1);
    KbWait;

    %Instructions
    text = 'One final reminder to please try to use all 4 confidence levels as much as possible!\n\nPress any key to begin with the experiment!';
    DrawFormattedText(window, text, 300, 'center', 255, p.wrapat);
    Screen('Flip',window);
    WaitSecs(1);
    KbWait;
    
    %Start sequence of runs
    for run_number=1:p.number_runs

        p.run = run_number;
        p.current_trial = 1;
        
        for block_number=1:p.number_blocks

            %Instructions
            number_run_string = num2str(run_number);
            number_block_string = num2str(block_number);
            text_run = ['RUN ' number_run_string '  (out of 4)'];
            text_block = ['BLOCK ' number_block_string '  (out of 6)'];
            DrawFormattedText(window, text_run, 'center',height/2-60, 255);
            DrawFormattedText(window, text_block, 'center',height/2-30, 255);
            Screen('Flip',window);
            WaitSecs(5);

            %Display the block
            p = one_block(window, width, height, p.trials_per_block, p);

            %end of block instructions
            if run_number < p.number_runs || block_number < p.number_blocks
                if block_number == p.number_blocks
                    DrawFormattedText(window, 'Take a break. Press any key when ready to continue with the next run.', 'center', 'center', 255, p.wrapat);
                else
                    DrawFormattedText(window, 'You have 15 seconds before the next block starts.', 'center', 'center', 255, p.wrapat);
                end
                Screen('Flip',window);
                if block_number == p.number_blocks
                    WaitSecs(1);
                    KbWait;
                else
                    WaitSecs(10);
                end
            end
            eval(['save ' p.text_results ' p']);
        end
        
        
    end

    DrawFormattedText(window, 'All done! Please, call the experimenter.','center','center', 255);
    Screen('Flip',window);
    WaitSecs(5);
    KbWait;

    %End. Close all windows
    Screen('CloseAll');

catch
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end