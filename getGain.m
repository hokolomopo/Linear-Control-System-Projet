function [G0, Wcp]=getGain(tfsysNoGain , wco)
    minGain=1;
    maxGain=100000;
    G0=(minGain+maxGain)/2;
    [~,~,~,Wcp] = margin(G0*tfsysNoGain);
    if(Wcp>wco) %Gain too high
        maxGain=G0;
        G0=(minGain+maxGain)/2;
    else
       minGain=G0;
       G0=(minGain+maxGain)/2;
    end
    while(abs(Wcp-wco)>0.01)
       [~,~,~,Wcp] = margin(G0*tfsysNoGain);
        if(Wcp>wco) %Gain to high
            maxGain=G0;
            G0=(minGain+maxGain)/2;
        else
            minGain=G0;
            G0=(minGain+maxGain)/2;
        end   
    end
end
