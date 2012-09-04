Vector3 = require("./vector3")

class Quaternion
  ###
  @class  Quaternion
  @brief A Quaternion describes a rotation in 3D space. It is mathematically defined as Q = x*i + y*j + z*k + w, where (i,j,k) are imaginary basis vectors. (x,y,z) can be seen as a vector related to the axis of rotation, while the real multiplier, w, is related to the amount of rotation.
  @param float x Multiplier of the imaginary basis vector i.
  @param float y Multiplier of the imaginary basis vector j.
  @param float z Multiplier of the imaginary basis vector k.
  @param float w Multiplier of the real part.
  @see http://en.wikipedia.org/wiki/Quaternion
  ###
  constructor: (x, y, z, w) ->
    
    ###
    @property float x
    @memberof /Quaternion
    ###
    @x = (if x isnt `undefined` then x else 0)
    
    ###
    @property float y
    @memberof  Quaternion
    ###
    @y = (if y isnt `undefined` then y else 0)
    
    ###
    @property float z
    @memberof  Quaternion
    ###
    @z = (if z isnt `undefined` then z else 0)
    
    ###
    @property float w
    @memberof  Quaternion
    @brief The multiplier of the real quaternion basis vector.
    ###
    @w = (if w isnt `undefined` then w else 1)


  ###
  Set the value of the quaternion.
  ###
  set: (x, y, z, w) ->
    @x = x
    @y = y
    @z = z
    @w = w


  ###
  @fn toString
  @memberof  Quaternion
  @brief Convert to a readable format
  @return string
  ###
  toString: ->
    @x + "," + @y + "," + @z + "," + @w


  ###
  @fn setFromAxisAngle
  @memberof  Quaternion
  @brief Set the quaternion components given an axis and an angle.
  @param Vector3 axis
  @param float angle in radians
  ###
  setFromAxisAngle: (axis, angle) ->
    s = Math.sin(angle * 0.5)
    @x = axis.x * s
    @y = axis.y * s
    @z = axis.z * s
    @w = Math.cos(angle * 0.5)


  # saves axis to targetAxis and returns 
  toAxisAngle: (targetAxis) ->
    targetAxis = targetAxis or new Vector3()
    @normalize() # if w>1 acos and sqrt will produce errors, this cant happen if quaternion is normalised
    angle = 2 * Math.acos(@w)
    s = Math.sqrt(1 - @w * @w) # assuming quaternion normalised then w is less than 1, so term always positive.
    if s < 0.001 # test to avoid divide by zero, s is always positive due to sqrt
      # if s close to zero then direction of axis not important
      targetAxis.x = @x # if it is important that axis is normalised then replace with x=1; y=z=0;
      targetAxis.y = @y
      targetAxis.z = @z
    else
      targetAxis.x = @x / s # normalise axis
      targetAxis.y = @y / s
      targetAxis.z = @z / s
    [targetAxis, angle]


  ###
  @fn setFromVectors
  @memberof  Quaternion
  @brief Set the quaternion value given two vectors. The resulting rotation will be the needed rotation to rotate u to v.
  @param Vector3 u
  @param Vector3 v
  ###
  setFromVectors: (u, v) ->
    a = u.cross(v)
    @x = a.x
    @y = a.y
    @z = a.z
    @w = Math.sqrt(Math.pow(u.norm(), 2) * Math.pow(v.norm(), 2)) + u.dot(v)
    @normalize()


  ###
  @fn mult
  @memberof  Quaternion
  @brief Quaternion multiplication
  @param  Quaternion q
  @param  Quaternion target Optional.
  @return  Quaternion
  ###
  mult: (q, target) ->
    target = new  Quaternion()  if target is `undefined`
    va = new Vector3(@x, @y, @z)
    vb = new Vector3(q.x, q.y, q.z)
    target.w = @w * q.w - va.dot(vb)
    vaxvb = va.cross(vb)
    target.x = @w * vb.x + q.w * va.x + vaxvb.x
    target.y = @w * vb.y + q.w * va.y + vaxvb.y
    target.z = @w * vb.z + q.w * va.z + vaxvb.z
    target


  ###
  @fn inverse
  @memberof  Quaternion
  @brief Get the inverse quaternion rotation.
  @param  Quaternion target
  @return  Quaternion
  ###
  inverse: (target) ->
    target = new  Quaternion()  if target is `undefined`
    @conjugate target
    inorm2 = 1 / (@x * @x + @y * @y + @z * @z + @w * @w)
    target.x *= inorm2
    target.y *= inorm2
    target.z *= inorm2
    target.w *= inorm2
    target


  ###
  @fn conjugate
  @memberof  Quaternion
  @brief Get the quaternion conjugate
  @param  Quaternion target
  @return  Quaternion
  ###
  conjugate: (target) ->
    target = new  Quaternion()  if target is `undefined`
    target.x = -@x
    target.y = -@y
    target.z = -@z
    target.w = @w
    target


  ###
  @fn normalize
  @memberof  Quaternion
  @brief Normalize the quaternion. Note that this changes the values of the quaternion.
  ###
  normalize: ->
    l = Math.sqrt(@x * @x + @y * @y + @z * @z + @w * @w)
    if l is 0
      @x = 0
      @y = 0
      @z = 0
      @w = 0
    else
      l = 1 / l
      @x *= l
      @y *= l
      @z *= l
      @w *= l


  ###
  @fn normalizeFast
  @memberof  Quaternion
  @brief Approximation of quaternion normalization. Works best when quat is already almost-normalized.
  @see http://jsperf.com/fast-quaternion-normalization
  @author unphased, https://github.com/unphased
  ###
  normalizeFast: ->
    f = (3.0 - (@x * @x + @y * @y + @z * @z + @w * @w)) / 2.0
    if f is 0
      @x = 0
      @y = 0
      @z = 0
      @w = 0
    else
      @x *= f
      @y *= f
      @z *= f
      @w *= f


  ###
  @fn vmult
  @memberof  Quaternion
  @brief Multiply the quaternion by a vector
  @param Vector3 v
  @param Vector3 target Optional
  @return Vector3
  ###
  vmult: (v, target) ->
    target = target or new Vector3()
    if @w is 0.0
      target.x = v.x
      target.y = v.y
      target.z = v.z
    else
      x = v.x
      y = v.y
      z = v.z
      qx = @x
      qy = @y
      qz = @z
      qw = @w
      
      # q*v
      ix = qw * x + qy * z - qz * y
      iy = qw * y + qz * x - qx * z
      iz = qw * z + qx * y - qy * x
      iw = -qx * x - qy * y - qz * z
      target.x = ix * qw + iw * -qx + iy * -qz - iz * -qy
      target.y = iy * qw + iw * -qy + iz * -qx - ix * -qz
      target.z = iz * qw + iw * -qz + ix * -qy - iy * -qx
    target


  ###
  @fn copy
  @memberof  Quaternion
  @param  Quaternion target
  ###
  copy: (target) ->
    target.x = @x
    target.y = @y
    target.z = @z
    target.w = @w


  ###
  @fn toEuler
  @memberof  Quaternion
  @brief Convert the quaternion to euler angle representation. Order: YZX, as this page describes: http://www.euclideanspace.com/maths/standards/index.htm
  @param Vector3 target
  @param string order Three-character string e.g. "YZX", which also is default.
  ###
  toEuler: (target, order) ->
    order = order or "YZX"
    heading = undefined
    attitude = undefined
    bank = undefined
    x = @x
    y = @y
    z = @z
    w = @w
    switch order
      when "YZX"
        test = x * y + z * w
        if test > 0.499 # singularity at north pole
          heading = 2 * Math.atan2(x, w)
          attitude = Math.PI / 2
          bank = 0
        if test < -0.499 # singularity at south pole
          heading = -2 * Math.atan2(x, w)
          attitude = -Math.PI / 2
          bank = 0
        if isNaN(heading)
          sqx = x * x
          sqy = y * y
          sqz = z * z
          heading = Math.atan2(2 * y * w - 2 * x * z, 1 - 2 * sqy - 2 * sqz) # Heading
          attitude = Math.asin(2 * test) # attitude
          bank = Math.atan2(2 * x * w - 2 * y * z, 1 - 2 * sqx - 2 * sqz) # bank
      else
        throw new Error("Euler order " + order + " not supported yet.")
    target.y = heading
    target.z = attitude
    target.x = bank


module.exports =  Quaternion

