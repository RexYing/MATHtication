[best list list_size] = find_fit(vertex_l, faces_l, vertex_u, faces_u);

new_v_l = transform(vertex_l, [-0.5 0 -2.5], [0, 0.0175, 0.0175]);
dist = check_intersect( vertex_l, faces_l, vertex_u, faces_u, [-0.5 0 -2.5], [0, 0.0175, 0.0175]);

obj1 = pqp_createmodel(new_v_l', faces_l');

dist = pqp_distance(obj1, obj2, eye(3), [0;0;0]);
i_points = pqp_intersect(obj1,obj2,eye(3),[0 0 0]',1);

pqp_deletemodel(obj1);