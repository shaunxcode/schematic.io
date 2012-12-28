#2D drawing helpers
#note the use of z to reduce impedence mismatch when using 3d coord system in which y is vertical 

#ported from http://mysite.verizon.net/res148h4j/javascript/script_circle_solver.html
solveCircle = (A, B, C) ->
    P = [
        [A.x, A.z]
        [B.x, B.z]
        [C.x, C.z]]
    
    a = [[0,0,0],[0,0,0],[0,0,0]]
    
    for i in [0..2]
        a[i][0] = P[i][0]
        a[i][1] = P[i][1]
        a[i][2] = 1

    m11 = determinant a, 3

    for i in [0..2]
        a[i][0] = P[i][0]*P[i][0] + P[i][1]*P[i][1]
        a[i][1] = P[i][1]
        a[i][2] = 1
    
    m12 = determinant a, 3

    for i in [0..2]
        a[i][0] = P[i][0]*P[i][0] + P[i][1]*P[i][1];
        a[i][1] = P[i][0]
        a[i][2] = 1;

    m13 = determinant a, 3

    for i in [0..2]
        a[i][0] = P[i][0]*P[i][0] + P[i][1]*P[i][1];
        a[i][1] = P[i][0];
        a[i][2] = P[i][1];

    m14 = determinant a, 3

    if m11 is 0
        r = 0
        x = 0
        y = 0
    else
        x =  0.5 * m12 / m11
        y = -0.5 * m13 / m11
        r  = Math.sqrt x * x + y * y + m14 / m11

    {center: {x: Math.floor(x), z: Math.floor(y)}, radius: Math.floor(r)}


determinant = (a, n) ->
    d = 0
    m = [[0,0,0],[0,0,0],[0,0,0]]

    if n is 2
        d = a[0][0] * a[1][1] - a[1][0] * a[0][1]
    else 
        d = 0
        for j1 in [0..n-1]
            for i in [1..n-1]
                j2 = 0;
                for j in [0..n-1]
                    continue if j is j1
                    m[i-1][j2] = a[i][j]
                    j2++
            
            d = d + Math.pow(-1.0, j1) * a[0][j1] * determinant( m, n-1 )
    d

lineLength = (A, B) -> 
    Math.sqrt (A.x -= B.x) * A.x + (A.z -= B.z) * A.z

point = (x, z) -> {x, z}

#http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
line = (p1, p2) ->
    points = []
    
    {x: x0, z: z0} = p1
    {x: x1, z: z1} = p2

    dx = Math.abs x1 - x0
    dz = Math.abs z1 - z0
    
    if x0 < x1 then sx = 1 else sx = -1
    if z0 < z1 then sz = 1 else sz = -1
    err = dx - dz
    
    loop 
        points.push point x0, z0
        if x0 is x1 and z0 is z1 then break
        e2 = 2 * err
        if e2 > -dz
            err = err - dz
            x0 = x0 + sx
        if e2 < dx
            err = err + dx
            z0 = z0 + sz

    points

rect = (p1, p2) ->
    a = p1
    b = x: p2.x, z: p1.z
    c = p2
    d = x: p1.x, z: p2.z

    line(a, b)
        .concat(line b, c)
        .concat(line c, d)
        .concat(line d, a)


#http://en.wikipedia.org/wiki/Midpoint_circle_algorithm
addPoint = (cx, cz, points, x, z, startAngle, stopAngle) ->
    if startAngle and stopAngle
        pangle = angleFromCenter cx, cz, x, z
        if not (pangle > startAngle and pangle < stopAngle)
            return

    points.push point x, z

plot4points = (cx, cz, x, z, startAngle, stopAngle) ->
    points = []
    addPoint cx, cz, points, cx + x, cz + z, startAngle, stopAngle
    if x isnt 0 then addPoint cx, cz, points, cx - x, cz + z, startAngle, stopAngle
    if z isnt 0 then addPoint cx, cz, points, cx + x, cz - z, startAngle, stopAngle
    if x isnt 0 and z isnt 0 then addPoint cx, cz, points, cx - x, cz - z, startAngle, stopAngle
    points
    
plot8points = (cx, cz, x, z, startPoint, stopPoint) ->
    points = plot4points cx, cz, x, z, startPoint, stopPoint
    if x isnt z then points = points.concat plot4points cx, cz, z, x, startPoint, stopPoint
    points
    
angleFromCenter = (cx, cz, px, pz) ->
    Math.atan2 pz - cz, px - cx

circle = (cp, radius, startPoint, stopPoint) ->
    {x: cx, z: cz} = cp
    error = -radius
    x = radius
    z = 0
    points = []
    if startPoint and stopPoint
        startAngle = angleFromCenter cx, cz, startPoint.x, startPoint.z
        stopAngle = angleFromCenter cx, cz, stopPoint.x, stopPoint.z
    else
        stopAngle = startAngle = undefined

    while x >= z
        points = points.concat plot8points cx, cz, x, z, startAngle, stopAngle
       
        error += z
        ++z
        error += z
        if error >= 0
            error -= x
            --x
            error -=x 

    points

arc = (p1, p2, p3) ->
    resolve = solveCircle p1, p2, p3
    if resolve.radius 
        circle resolve.center, resolve.radius, p1, p3

module.exports = {point, line, rect, circle, arc}