#import "Math";
vector_cases :: () -> bool {
    if size_of(Vector2)!=8 || size_of(Vector3)!=12 || size_of(Vector4)!=16 return false;
    a:=make_vector3(3,4,0);
    if length(a)!=5 || dot(a,a)!=25 return false;
    normalized:=normalize(a);
    if abs(normalized.x-0.6)>0.000001 || abs(normalized.y-0.8)>0.000001 return false;
    if cross_product(make_vector3(1,0,0),make_vector3(0,1,0))!=make_vector3(0,0,1) return false;
    mixed:=lerp(make_vector3(0,2,4),make_vector3(2,4,6),0.5);
    if mixed!=make_vector3(1,3,5) return false;
    if abs(cast(s64) -7)!=7 || abs(cast(int) -7)!=7 return false;
    if min(cast(int) 4,cast(int) 3,cast(int) 2,cast(int) 1)!=1 return false;
    if min(cast(int) 4,cast(int) 2)!=2 || max(cast(float) 4,cast(float) 2)!=4 return false;
    if clamp(cast(float) 2,cast(float) 0,cast(float) 1)!=1 return false;
    return true;
}
quaternion_cases :: () -> bool {
    q: Quaternion;
    if q.w!=0 return false;
    set_from_axis_and_angle(*q,axis=make_vector3(0,0,1),angle=cast(float) (PI64*0.5));
    rotated:=rotate(make_vector3(1,0,0),q);
    if abs(rotated.x)>0.00001 || abs(rotated.y-1)>0.00001 || abs(rotated.z)>0.00001 return false;
    blended:=slerp(a=Quaternion_Identity,b=q,t=0.5);
    x,y,z,theta:=get_axis_and_angle(blended);
    if abs(theta-PI64*0.25)>0.00001 || abs(z-1)>0.00001 return false;
    return true;
}
matrix_cases :: () -> bool {
    if size_of(Matrix3)!=36 || size_of(Matrix4)!=64 return false;
    m:=Matrix4_Identity;
    m._11=2; m._22=3; m._33=4; m._14=5;
    transformed:=multiply(m,make_vector4(1,2,3,1));
    if transformed!=make_vector4(7,6,12,1) return false;
    inverse_matrix,success:=inverse(m);
    if !success return false;
    product:=multiply(m,inverse_matrix);
    for r: 0..3 for c: 0..3 {
        expected:=0.0; if r==c expected=1;
        if abs(product.coef[r][c]-expected)>0.00001 return false;
    }
    singular: Matrix4;
    failed,was_inverted:=inverse(singular);
    if was_inverted return false;
    return true;
}
#assert #run vector_cases();
#assert #run quaternion_cases();
#assert #run matrix_cases();
