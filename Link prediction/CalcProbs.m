function [PD,PF] = CalcProbs(th,G,rm)
    %CALCPROBS Given a graph, a random hidding of the edges and a threshold
    %it returns the Prob. of Detection and the Prob. of False Alarm.
    s_rm = rm(:,1);
    t_rm = rm(:,2);

    G_obs = rmedge(G,s_rm, t_rm);
    G_pred = G_obs;
    predicted_true = [];
    
    for i = 1:size(rm,1)%Changed rm for rc -> Score just for unknown edges
%         disp(['Checking edge (', num2str(rm(i,1)), ',', num2str(rm(i,2)), ')']);
        score = CNScoring(G_obs, rm(i,1), rm(i,2));
        if score>=th
%            disp(['Edge (', num2str(rm(i,1)), ',', num2str(rm(i,2)), ') is added...'])
           G_pred = addedge(G_pred, rm(i,1), rm(i,2), 1);
           predicted_true = [predicted_true; rm(i,:)];
        else
           G_pred = rmedge(G_pred, rm(i,1), rm(i,2));
        end    
    end
    
    %% Plot corrected
    % figure(3);
    % plot(G_pred)
    % title('Graph predicted');
    
    %% Probability of detection and false alarm
    [s_G, t_G] = findedge(G);
    [s_G_pred, t_G_pred] = findedge(G_pred);
    idx_G = [s_G, t_G];
    idx_G_pred = [s_G_pred, t_G_pred];
    
    predicted_true_1 = 0;
    for i = 1:size(predicted_true,1)
        for j = 1:size(idx_G,1)
            if all(predicted_true(i, :) == idx_G(j,:))
                predicted_true_1 = predicted_true_1 + 1;
            end
        end
    end
    
    to_be_true_1 = 0;
    for i = 1:size(rm,1)
        for j = 1:size(idx_G,1)
            if all(rm(i, :) == idx_G(j,:))
                to_be_true_1 = to_be_true_1 + 1;
            end
        end
    end
    
    predicted_false_1 = size(predicted_true, 1) - predicted_true_1;% All predicted as 1 minus the real predicted as 1;
    to_be_false_0 = size(rm,1) - to_be_true_1;
    PD = predicted_true_1/to_be_true_1;
    PF = predicted_false_1/to_be_false_0;

end

