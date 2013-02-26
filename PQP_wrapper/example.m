[V,F]=read_off('../../../meshes/examples/mushroom.off');

obj1 = pqp_createmodel(V,F);
obj2 = pqp_createmodel(V+0.1,F);

answer = pqp_intersect(obj1,obj2,eye(3),[0 0 0]',0)
%The rotation and translation are applied to obj1, and then it is compared
%to obj2.

distance = pqp_distance(obj1,obj2,eye(3),[100 0 0]');
%distance

pqp_deletemodel(obj1);
pqp_deletemodel(obj2);