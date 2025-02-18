function test_parameter_fcost(p)
% p=[5.9663    0.5111    0.5231   19.9758 0.039604473495884] % problem 1, corrida 4 daba NaN -> condiciòn inicial loop [0 -1]
% p=[0.5000    0.8166    0.9983   13.3296 0.039604473495884] % problem 2, continua molestando. -> try catch
p= [5.9997    0.4824    0.9982   19.9998 0.039604473495884*1.2] % Resultado todas calibrando
% p=[5.9994    0.9991    1.0000   19.9977]
load('destilaciones_qcte')

%% Setting initial condition vector - Simulink integrator
load('X0_ini_ev') %% 6/7/2018 20:06 cond_inicialx0.m % Cmet=1.5; % V=40; % GA=13; % N=21;
x0_ini2=x0_ini;N=7;No=6;  x0_ini=zeros(4*N+No,1);
x0_ini(1)=x0_ini2(1);x0_ini(2)=x0_ini2(2);x0_ini(3)=x0_ini2(3);
for J=1:N
  x0_ini(4*J+0)=(x0_ini2(4*J+0+8*(J-1))+x0_ini2(4*J+4+8*(J-1))+x0_ini2(4*J+8+8*(J-1)))/3;
  x0_ini(4*J+1)=(x0_ini2(4*J+1+8*(J-1))+x0_ini2(4*J+5+8*(J-1))+x0_ini2(4*J+9+8*(J-1)))/3+0.01;
  x0_ini(4*J+2)=(x0_ini2(4*J+2+8*(J-1))+x0_ini2(4*J+6+8*(J-1))+x0_ini2(4*J+10+8*(J-1)))/3;
  x0_ini(4*J+3)=(x0_ini2(4*J+3+8*(J-1))+x0_ini2(4*J+7+8*(J-1))+x0_ini2(4*J+11+8*(J-1)))/3;
end
b=2;a=1;
x_min=[1767.71545621850;0.00799041062661984;3.41060000832915e-05;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0;0;0];
x_max=[2018.07587071285;0.624753322576231;0.000637824871562298;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;65.8799169826809;0.143158013086597;184.381691331991];
x_range=[250.360414494350;0.616762911949612;0.000603718871479006;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;65.8799169826809;0.143158013086597;184.381691331991];
x_ss=0.5*(x_max+x_min);
x0_ini(4*N+3+1:4*N+No-1)=0;  % estados auxiliares 

ini_ode.x0_ini=x0_ini;
ini_ode.a=a;
ini_ode.b=b;
ini_ode.x_range=x_range;
ini_ode.x_ss=x_ss;

%% Desde Aquì copiar o hacer funciòn para test

% Parameters
% Mcp_c=4;
% Phi_ef=0.70;
% Eff_area=0.2;  %mL volumen
% Q_loss=15; % watt
Mcp_c=   p(1);  % Cp*m metal
Phi_ef=  p(2);  % Factor eficiencia area transf. masa
Eff_area=p(3);  % Factor eficiencia area transf. calor
Q_loss=  p(4);  % watt

x0_ini(2)=p(5); % Valor inicial etanol boiler
% Entrada constante
Qb=1000;        % Potencia calefacciòn boiler W
m_s=10; % Primeros puntos descartados
m_f=10; % Ultimos puntos descartados

Qc_v_total=[140 140 140 140 200 200 200 250 250 250];
dist_index=[1 2 3 4 5 6 7 8 9 10] ;
Qc_v=Qc_v_total(dist_index);
% Parametros
Mcp_c=   p(1);  % Cp*m metal
Phi_ef=  p(2);  % Factor eficiencia area transf. masa
Eff_area=p(3);  % Factor eficiencia area transf. calor
Q_loss=  p(4);  % watt
opts = simset('SrcWorkspace','current','DstWorkspace','current');


% Bucle for para correr las destilaciones
for i=1;%1:length(dist_index)
    i
    Qc=Qc_v(i);
    dist_exp(i)=destilaciones(dist_index(i)); % aux. matriz de datos exp.
    T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
    T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
    Tin=mean(dist_exp{i}(:,3));               % aux. promedio temp in exp.
    % Ejecutar simulación desde simulink
    simout{i}=sim('destilador_14',[0 T_fin],opts,[]);
    % Extracción y re-muestreo según tiempo experimental
    data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
    dist_model{i}=data_n_rs.Data(:,:);

    Jy(i)=sum(((dist_exp{i}(m_s:end-m_f,6)-dist_model{i}(m_s:end-m_f,1))./max(dist_exp{i}(m_s:end-m_f,6))).^2)
    Ju(i)=sum(((dist_exp{i}(m_s:end-m_f,4)-dist_model{i}(m_s:end-m_f,8))./max(dist_exp{i}(m_s:end-m_f,4))).^2)
end

close all
figure (1)
lw1=0.5;
lw2=1;
for i=1:4
    subplot(3,3,1)
    plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,6),'--','Linewidth',lw1,'Color',[(((1-0.5)/(4-1))*(i-1)+0.5) 0 0]); hold on  
    plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,1),'Linewidth',lw2,'Color',[(((1-0.5)/(4-1))*(i-1)+0.5) 0 0]); hold on
    ylabel('Aº_d (%v/v)')
    xlabel('Time (h)')
    title({'Q_c = 140 W','Calibration'})
    grid on
    
    subplot(3,3,4)
    plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,7),'--','Linewidth',lw1,'Color',[(((1-0.5)/(4-1))*(i-1)+0.5) 0 0]); hold on  
    plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,7),'Linewidth',lw2,'Color',[(((1-0.5)/(4-1))*(i-1)+0.5) 0 0]); hold on  
%     title('Coolant flow, mL/min')
    ylabel('F_c (mL/min)')
    xlabel('Time, h')
    grid on
    
    subplot(3,3,7)
    plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,4),'--','Linewidth',lw1,'Color',[(((1-0.5)/(4-1))*(i-1)+0.5) 0 0]); hold on 
    plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,8),'Linewidth',lw2,'Color',[(((1-0.5)/(4-1))*(i-1)+0.5) 0 0]); hold on
%     title('Oulet Coolant Temperature, ºC')
        ylabel('T_o_u_t (ºC)')
    xlabel('Time, h')
    grid on
 end

          for i=5:7
            subplot(3,3,2)
            plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,6),'--','Linewidth',lw1,'Color',[0 (((1-0.5)/(7-5))*(i-5)+0.5) 0]); hold on  
            plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,1),'Linewidth',lw2,'Color',[0 (((1-0.5)/(7-5))*(i-5)+0.5) 0]); hold on
%             title('Ethanol concentration, %v/v')
    title({'Q_c = 200 W','Validation'})
    ylabel('Aº_d (%v/v)')
    xlabel('Time (h)')
            grid on

            subplot(3,3,5)
            plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,7),'--','Linewidth',lw1,'Color',[0 (((1-0.5)/(7-5))*(i-5)+0.5) 0]); hold on 
            plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,7),'Linewidth',lw2,'Color',[0 (((1-0.5)/(7-5))*(i-5)+0.5) 0]); hold on  
%             title('Coolant flow, mL/min')
                ylabel('F_c (mL/min)')
    xlabel('Time (h)')
            grid on

            subplot(3,3,8)
            plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,4),'--','Linewidth',lw1,'Color',[0 (((1-0.5)/(7-5))*(i-5)+0.5) 0]); hold on 
            plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,8),'Linewidth',lw2,'Color',[0 (((1-0.5)/(7-5))*(i-5)+0.5) 0]); hold on  
%     title('Oulet Coolant Temperature, ºC')
        ylabel('T_o_u_t (ºC)')
    xlabel('Time (h)')
            grid on
          end
         
                    for i=8:10
                        subplot(3,3,3)
                        plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,6),'--','Linewidth',lw1,'Color',[0 0 (((1-0.5)/(10-8))*(i-8)+0.5)]); hold on
                        plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,1),'Linewidth',lw2,'Color',[0 0 (((1-0.5)/(10-8))*(i-8)+0.5)]); hold on
%                         title('Ethanol concentration, %v/v')
    title({'Q_c = 250 W','Calibration'})
    ylabel('Aº_d (%v/v)')
    xlabel('Time (h)')
                        grid on

                        subplot(3,3,6)
                        plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,7),'--','Linewidth',lw1,'Color',[0 0 (((1-0.5)/(10-8))*(i-8)+0.5)]); hold on  
                        plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,7),'Linewidth',lw2,'Color',[0 0 (((1-0.5)/(10-8))*(i-8)+0.5)]); hold on  
%                         title('Coolant flow, mL/min')
                ylabel('F_c (mL/min)')
    xlabel('Time (h)')
                        grid on

                        subplot(3,3,9)
                        plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,4),'--','Linewidth',lw1,'Color',[0 0 (((1-0.5)/(10-8))*(i-8)+0.5)]); hold on 
                        plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,8),'Linewidth',lw2,'Color',[0 0 (((1-0.5)/(10-8))*(i-8)+0.5)]); hold on  
%        title('Oulet Coolant Temperature, ºC')
        ylabel('T_o_u_t (ºC)')
    xlabel('Time (h)')
                        grid on
                    end
                     sgtitle('Model Calibration - Constant Removed Heat')
                     grid on
                     set(gcf,'color','white')
                     
J=sum(Jy)+sum(Ju)*0
