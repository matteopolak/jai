Plane3 :: struct {
    a, b, c, d: float;
}
make_plane :: (a: float, b: float, c: float, d: float) -> Plane3 { return .{a,b,c,d}; }
make_plane :: (v: Vector3, d: float) -> Plane3 { return make_plane(v.x,v.y,v.z,d); }
make_plane :: (v: Vector3, x: Vector3) -> Plane3 { return plane_from_point_and_normal(x,v); }
plane_from_point_and_normal :: (point: Vector3, normal: Vector3) -> Plane3 { return make_plane(normal,-dot(point,normal)); }
make_plane :: (v: Vector4) -> Plane3 { return make_plane(xyz(v.x,v.y,v.z),v.w); }
get_normal :: (p: Plane3) -> Vector3 { return xyz(p.a,p.b,p.c); }
normalize :: (using p: Plane3) -> Plane3 {
    normal:=get_normal(p);
    magnitude:=length(normal);
    if magnitude==0 return p;
    return make_plane(normal/magnitude,d/magnitude);
}
normalized_plane_from_points :: (p0: Vector3, p1: Vector3, p2: Vector3) -> Plane3 {
    normal:=normalize(cross(p1-p0,p2-p0));
    return plane_from_point_and_normal(p0,normal);
}
plane_dot :: (plane: Plane3, v: Vector3) -> float { return dot(get_normal(plane),v)+plane.d; }
plane_dot :: (v: Vector3, plane: Plane3) -> float { return plane_dot(plane,v); }
