#2D drawing helpers
#ote the use of z to reduce impedence mismatch when using 3d coord system in which y is vertical 

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
plot4points = (cx, cz, x, z) ->
    points = [[cx + x, cz + z]]
    if x isnt 0 then points.push [cx - x, cz + z]
    if z isnt 0 then points.push [cx + x, cz - z]
    if x isnt 0 and z isnt 0 then points.push [cx - x, cz - z ]
    points
    
plot8points = (cx, cz, x, z) ->
    points = plot4points cx, cz, x, z
    if x isnt z then points = points.concat plot4points cx, cz, z, x
    points
    
circle = (cp, radius) ->
    {x, z} = cp
    error = -radius
    x = radius
    z = 0
    points = []
    while x >= z
        points = points.concat plot8points cx, cz, x, z
       
        error += z
        ++z
        error += z
        if error >= 0
            error -= x
            --x
            error -=x 

    points

curve = (p1, p2, p3) ->



module.exports = {point, line, rect, circle, curve}