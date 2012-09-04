
class Vector3
  ###
  @class Vector3
  @brief 3-dimensional vector
  @param float x
  @param float y
  @param float z
  @author schteppe
  ###
  constructor: (x, y, z) ->
    
    ###
    @property float x
    @memberof Vector3
    ###
    @x = x or 0.0
    
    ###
    @property float y
    @memberof Vector3
    ###
    @y = y or 0.0
    
    ###
    @property float z
    @memberof Vector3
    ###
    @z = z or 0.0


  ###
  @fn cross
  @memberof Vector3
  @brief Vector cross product
  @param Vector3 v
  @param Vector3 target Optional. Target to save in.
  @return Vector3
  ###
  cross: (v, target) ->
    target = target or new Vector3()
    A = [@x, @y, @z]
    B = [v.x, v.y, v.z]
    target.x = (A[1] * B[2]) - (A[2] * B[1])
    target.y = (A[2] * B[0]) - (A[0] * B[2])
    target.z = (A[0] * B[1]) - (A[1] * B[0])
    target


  ###
  @fn set
  @memberof Vector3
  @brief Set the vectors 3 elements
  @param float x
  @param float y
  @param float z
  @return Vector3
  ###
  set: (x, y, z) ->
    @x = x
    @y = y
    @z = z
    this


  ###
  @fn vadd
  @memberof Vector3
  @brief Vector addition
  @param Vector3 v
  @param Vector3 target Optional.
  @return Vector3
  ###
  vadd: (v, target) ->
    if target
      target.x = v.x + @x
      target.y = v.y + @y
      target.z = v.z + @z
    else
      new Vector3(@x + v.x, @y + v.y, @z + v.z)


  ###
  @fn vsub
  @memberof Vector3
  @brief Vector subtraction
  @param Vector3 v
  @param Vector3 target Optional. Target to save in.
  @return Vector3
  ###
  vsub: (v, target) ->
    if target
      target.x = @x - v.x
      target.y = @y - v.y
      target.z = @z - v.z
    else
      new Vector3(@x - v.x, @y - v.y, @z - v.z)


  ###
  @fn crossmat
  @memberof Vector3
  @brief Get the cross product matrix a_cross from a vector, such that a x b = a_cross * b = c
  @see http://www8.cs.umu.se/kurser/TDBD24/VT06/lectures/Lecture6.pdf
  @return Matrix3
  ###
  crossmat: ->
    new Matrix3([0, -@z, @y, @z, 0, -@x, -@y, @x, 0])


  ###
  @fn normalize
  @memberof Vector3
  @brief Normalize the vector. Note that this changes the values in the vector.
  @return float Returns the norm of the vector
  ###
  normalize: ->
    n = Math.sqrt(@x * @x + @y * @y + @z * @z)
    if n > 0.0
      @x /= n
      @y /= n
      @z /= n
    else
      
      # Make something up
      @x = 0
      @y = 0
      @z = 0
    n


  ###
  @fn unit
  @memberof Vector3
  @brief Get the version of this vector that is of length 1.
  @param Vector3 target Optional target to save in
  @return Vector3 Returns the unit vector
  ###
  unit: (target) ->
    target = target or new Vector3()
    ninv = Math.sqrt(@x * @x + @y * @y + @z * @z)
    if ninv > 0.0
      ninv = 1.0 / ninv
      target.x = @x * ninv
      target.y = @y * ninv
      target.z = @z * ninv
    else
      target.x = 0
      target.y = 0
      target.z = 0
    target


  ###
  @fn norm
  @memberof Vector3
  @brief Get the 2-norm (length) of the vector
  @return float
  ###
  norm: ->
    Math.sqrt @x * @x + @y * @y + @z * @z


  ###
  @fn norm2
  @memberof Vector3
  @brief Get the squared length of the vector
  @return float
  ###
  norm2: ->
    @dot this

  distanceTo: (p) ->
    Math.sqrt (p.x - @x) * (p.x - @x) + (p.y - @y) * (p.y - @y) + (p.z - @z) * (p.z - @z)


  ###
  @fn mult
  @memberof Vector3
  @brief Multiply the vector with a scalar
  @param float scalar
  @param Vector3 target
  @return Vector3
  ###
  mult: (scalar, target) ->
    target = new Vector3()  unless target
    target.x = scalar * @x
    target.y = scalar * @y
    target.z = scalar * @z
    target


  ###
  @fn dot
  @memberof Vector3
  @brief Calculate dot product
  @param Vector3 v
  @return float
  ###
  dot: (v) ->
    @x * v.x + @y * v.y + @z * v.z


  ###
  @fn isZero
  @memberof Vector3
  @return bool
  ###
  isZero: ->
    @x is 0 and @y is 0 and @z is 0


  ###
  @fn negate
  @memberof Vector3
  @brief Make the vector point in the opposite direction.
  @param Vector3 target Optional target to save in
  @return Vector3
  ###
  negate: (target) ->
    target = target or new Vector3()
    target.x = -@x
    target.y = -@y
    target.z = -@z
    target


  ###
  @fn tangents
  @memberof Vector3
  @brief Compute two artificial tangents to the vector
  @param Vector3 t1 Vector object to save the first tangent in
  @param Vector3 t2 Vector object to save the second tangent in
  ###
  tangents: (t1, t2) ->
    norm = @norm()
    if norm > 0.0
      n = new Vector3(@x / norm, @y / norm, @z / norm)
      if n.x < 0.9
        rand = Math.random()
        n.cross new Vector3(rand, 0.0000001, 0).unit(), t1
      else
        n.cross new Vector3(0.0000001, rand, 0).unit(), t1
      n.cross t1, t2
    else
      
      # The normal length is zero, make something up
      t1.set(1, 0, 0).normalize()
      t2.set(0, 1, 0).normalize()


  ###
  @fn toString
  @memberof Vector3
  @brief Converts to a more readable format
  @return string
  ###
  toString: ->
    @x + "," + @y + "," + @z


  ###
  @fn copy
  @memberof Vector3
  @brief Copy the vector.
  @param Vector3 target
  @return Vector3
  ###
  copy: (target) ->
    target = target or new Vector3()
    target.x = @x
    target.y = @y
    target.z = @z
    target


  ###
  @fn lerp
  @memberof Vector3
  @brief Do a linear interpolation between two vectors
  @param Vector3 v
  @param float t A number between 0 and 1. 0 will make this function return u, and 1 will make it return v. Numbers in between will generate a vector in between them.
  @param Vector3 target
  ###
  lerp: (v, t, target) ->
    target.x = @x + (v.x - @x) * t
    target.y = @y + (v.y - @y) * t
    target.z = @z + (v.z - @z) * t


  ###
  @fn almostEquals
  @memberof Vector3
  @brief Check if a vector equals is almost equal to another one.
  @param Vector3 v
  @param float precision
  @return bool
  ###
  almostEquals: (v, precision) ->
    precision = 1e-6  if precision is `undefined`
    return false  if Math.abs(@x - v.x) > precision or Math.abs(@y - v.y) > precision or Math.abs(@z - v.z) > precision
    true


  ###
  Check if a vector is almost zero
  ###
  almostZero: (precision) ->
    precision = 1e-6  if precision is `undefined`
    return false  if Math.abs(@x) > precision or Math.abs(@y) > precision or Math.abs(@z) > precision
    true

module.exports = Vector3

