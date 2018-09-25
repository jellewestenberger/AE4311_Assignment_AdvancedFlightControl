Clrls=load('Cl_RLS_run01.mat')
timestruct=dat2dict(Clrls);
save('Clrls.mat','timestruct');


function timestruct= dat2dict(aci)
timestruct={};
coefname={};
coefvalue={};
for id=1:(aci.data.numElements())
    name=aci.data{id}.Values.Name;
    coefname=[coefname,name];
    timestruct{id}=aci.data{id}.Values;
    a=timestruct{id}
    save strcat(num2str(id),'.mat' 'a'
end
end