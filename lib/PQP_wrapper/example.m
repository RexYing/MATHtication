[V,F]=read_off('tetrahedron.off');

obj1 = pqp_createmodel(V,F);
obj2 = pqp_createmodel(V+2,F);

%answer = pqp_intersect(obj1,obj2,eye(3),[0 0 0]',0);
answer = pqp_intersect(obj1,obj2,eye(3),[0 0 0]',1);
%The rotation and translation are applied to obj1, and then it is compared
%to obj2.

distance = pqp_distance(obj1,obj2,eye(3),[0 0 0]');
%distance

pqp_deletemodel(obj1);
pqp_deletemodel(obj2);
