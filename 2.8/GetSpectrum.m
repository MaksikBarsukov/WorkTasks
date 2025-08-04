function [f, as, n] = GetSpectrum(Signal, SampleRate)
    
    ft = fft(Signal);
    n = length(Signal);
    
    for j=1:n
        if (j==1)
            as(j)=sqrt(real(ft(j))^2+imag(ft(j))^2)/n;
        else
            as(j)=sqrt(real(ft(j))^2+imag(ft(j))^2)/n*2;
        end
    end
    
    df = SampleRate/n;
    for j=1:(n/2)
        f(j)=df*(j-1); 
    end

end

