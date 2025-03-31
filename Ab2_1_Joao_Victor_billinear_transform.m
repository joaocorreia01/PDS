% Transformação Bilinear de um Filtro Butterworth - Exemplo 7.3 (Oppenheim)


% Especificações do filtro em tempo discreto
wp = 0.01; % Frequência de passagem ajustada para evitar zero % Frequência de passagem (normalizada)
ws = 0.3 * pi; % Frequência de rejeição (normalizada)
ap = -20 * log10(0.89125); % Atenuação na banda de passagem (dB)
as_ = -20 * log10(0.17783); % Atenuação na banda de rejeição (dB)

% Mapeamento para o tempo contínuo via Transformação Bilinear
fs = 1; % Frequência de amostragem normalizada
wp_analog = 2 * fs * tan(wp / 2); % Frequência de passagem no tempo contínuo
ws_analog = 2 * fs * tan(ws / 2); % Frequência de rejeição no tempo contínuo

% Projeto do filtro Butterworth
[N, Wn] = buttord(wp_analog, ws_analog, ap, as_, 's');
[b, a] = butter(N, Wn, 's');

% Transformação Bilinear para obter H(z)
[bz, az] = bilinear(b, a, fs);

% Plotando as respostas em frequência
[H, w] = freqs(b, a);
[Hz, wz] = freqz(bz, az, 1024);

figure;
subplot(2,1,1);
semilogx(w, 20*log10(abs(H)), 'b');
title('Diagrama de Bode - Tempo Contínuo');
xlabel('Frequência (rad/s)');
ylabel('Magnitude (dB)');
grid on;
legend('H(s)');

subplot(2,1,2);
plot(wz/pi, 20*log10(abs(Hz)), 'r');
title('Diagrama de Bode - Tempo Discreto');
xlabel('Frequência Normalizada (x π rad/amostra)');
ylabel('Magnitude (dB)');
grid on;
legend('H(z)');

% Comparação da resposta ao impulso
figure;
subplot(2,1,1);
impulse(tf(bs, as)); % Resposta ao impulso do sistema contínuo
title('Resposta ao Impulso - Filtro Analógico H(s)');

subplot(2,1,2);
impz(bz, az); % Resposta ao impulso do sistema discreto
title('Resposta ao Impulso - Filtro Digital H(z)');

% Comparação da resposta ao degrau
figure;
subplot(2,1,1);
step(tf(bs, as)); % Resposta ao degrau do sistema contínuo
title('Resposta ao Degrau - Filtro Analógico H(s)');

subplot(2,1,2);
stepz(bz, az); % Resposta ao degrau do sistema discreto
title('Resposta ao Degrau - Filtro Digital H(z)');

% Teste do desempenho com sinal de entrada
t = linspace(0, 1, 1000);
x = sin(2 * pi * 0.1 * t) + sin(2 * pi * 0.4 * t); % Sinal de entrada

y_analog = filter(b, a, x); % Filtro no tempo contínuo
y_digital = filter(bz, az, x); % Filtro no tempo discreto

figure;
plot(t, x, 'k', 'DisplayName', 'Sinal de Entrada');
hold on;
plot(t, y_analog, '--b', 'DisplayName', 'Saída H(s)');
plot(t, y_digital, ':r', 'DisplayName', 'Saída H(z)');
title('Resposta do Filtro a um Sinal de Entrada');
xlabel('Tempo (s)');
ylabel('Amplitude');
legend;
grid on;
