clear
%% initialization
group_size=7;
timestep=10;
tribalism=-0.05; %-1 to 1
k_value=(tribalism+1)/2;
probA_init=0.48;
probB_init=1-probA_init;
%% population generation
syms x
roots=vpasolve(legendreP(group_size,x)==0);
pop_prop=2*(1-power(roots,2))./(power(group_size+1,2).*power(legendreP(group_size+1,roots),2));
pop_prop=double(pop_prop)./2;
%% probability
probA_T=zeros(timestep+1,1);
probA_T(1)=probA_init;
probA2_T=zeros(timestep+1,1);
probA2_T(1)=probA_init;
probB_T=zeros(timestep+1,1);
probB_T(1)=probB_init;
for time=1:timestep
    if time==4
        tribalism=0.80; %-1 to 1
        k_value=(tribalism+1)/2;
        probA_T(4)=0.38;
        probA2_T(4)=0.36;
        probB_T(4)=1-probA_T(3);
    end
    dummyPt=zeros(group_size,1);
    dummyPt2=zeros(group_size,1);
    for r=1:group_size
        if mod(r,2)==1
            dummyPr=zeros((r+1)/2,1);
            dummyPr2=zeros((r+1)/2,1);
            m=(r+1)/2;
            for idx=1:(r+1)/2
                dummyPr(idx)=nchoosek(r,m)*power(probA_T(time),m)*power(1-probA_T(time),r-m);
                dummyPr2(idx)=nchoosek(r,m)*power(probA2_T(time),m)*power(1-probA2_T(time),r-m);
                m=m+1;
            end
        else
            dummyPr=zeros(r/2,1);
            dummyPr2=zeros(r/2,1);
            m=(r/2)+1;
            for idx=1:r/2
                dummyPr(idx)=nchoosek(r,m)*power(probA_T(time),m)*power(1-probA_T(time),r-m);
                dummyPr2(idx)=nchoosek(r,m)*power(probA2_T(time),m)*power(1-probA2_T(time),r-m);
                m=m+1;
            end
            Pr_right=k_value*nchoosek(r,r/2)*power(probA_T(time),r/2)*power(1-probA_T(time),r/2);
            Pr_right2=k_value*nchoosek(r,r/2)*power(probA2_T(time),r/2)*power(1-probA2_T(time),r/2);
            dummyPr(end)=dummyPr(end)+Pr_right;
            dummyPr2(end)=dummyPr2(end)+Pr_right2;
        end
        dummyPt(r)=pop_prop(r)*sum(dummyPr);
        dummyPt2(r)=pop_prop(r)*sum(dummyPr2);
    end
    probA_T(time+1)=sum(dummyPt);
    probA2_T(time+1)=sum(dummyPt2);
    probB_T(time+1)=1-sum(dummyPt);
end
%% plotting
plot(1:3,probA_T(1:3))
ylim([0 1])
xlim([1 10])
hold on
scatter(1:2,probA_T(1:2))
scatter(3,probA_T(3))
plot(3:timestep,probA_T(4:end))
scatter(3:timestep,probA_T(4:end))
plot(3:timestep,probA2_T(4:end))
scatter(3:timestep,probA2_T(4:end))
% gridlines
xl = xlim;
yl = ylim;
plot(xl,ones(1,2)*yl(1), '-k',  ones(1,2)*xl(1), yl,'-k', 'LineWidth',2.0)  % Left & Lower Axes
plot(xl,ones(1,2)*yl(2), '-k',  ones(1,2)*xl(2), yl,'-k', 'LineWidth',2.0)  % Right & Upper Axes
hold off
grid
yticks([0 0.2 0.4 0.6 0.8 1])
ylabel('Popularitas')
xlabel('Debat ke-n')
