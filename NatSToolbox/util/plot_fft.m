function plot_fft(fft_coefs, SR)
    N = length(fft_coefs);
    SI = 1/SR;
    nyquist_frequency = SR/2;
    half_of_frequency = floor(N/2)+1;
    
    frequencies = linspace(0, nyquist_frequency, half_of_frequency);
    
    plot(frequencies, abs(fft_coefs(1:half_of_frequency)).^2, 'b-');
    
end