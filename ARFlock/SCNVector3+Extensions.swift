//
//  SCNVector3+Extensions.swift
//  ARFlock
//
//  Created by Christopher Webb on 1/9/23.
//

import Foundation
import SceneKit



extension SCNVector3 {
    /**
     * Negates the vector described by SCNVector3 and returns
     * the result as a new SCNVector3.
     */
    func negate() -> SCNVector3 {
        return self * -1
    }
    
    /**
     * Negates the vector described by SCNVector3
     */
    mutating func negated() -> SCNVector3 {
        self = negate()
        return self
    }
    
    /**
     * Returns the length (magnitude) of the vector described by the SCNVector3
     */
    func length() -> Float {
        return sqrtf(((Float(x) * Float(x)) + (Float(y) * Float(y))) + (Float(z) * Float(z)))
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
    func normalized() -> SCNVector3 {
        return self / length()
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0.
     */
    mutating func normalize() -> SCNVector3 {
        self = normalized()
        return self
    }
    
    /**
     * Calculates the distance between two SCNVector3. Pythagoras!
     */
    func distance(_ vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    
    /**
     * Calculates the dot product between two SCNVector3.
     */
    func dot(_ vector: SCNVector3) -> Float {
        return (((Float(x) * Float(vector.x)) + (Float(y) * Float(vector.y))) + (Float(z) * Float(vector.z)))
    }
    
    /**
     * Calculates the cross product between two SCNVector3.
     */
    func cross(_ vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make( ((y * vector.z) - (z * vector.y)), ((z * vector.x) - (x * vector.z)), ((x * vector.y) - (y * vector.x)))
    }
}

/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
infix operator +
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Increments a SCNVector3 with the value of another.
 */
func += (left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
infix operator -
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 * Decrements a SCNVector3 with the value of another.
 */
func -= (left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 * Multiplies two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
infix operator *
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Multiplies a SCNVector3 with another.
 */
func *= (left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
 * returns the result as a new SCNVector3.
 */

func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * Float(scalar), vector.y * Float(scalar), vector.z * Float(scalar))
}

/**
 * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
 */
func *= (vector: inout SCNVector3, scalar: Float) {
    vector = vector * scalar
}

/**
 * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
 */
infix operator /
func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 * Divides a SCNVector3 by another.
 */
func /= (left: inout SCNVector3, right: SCNVector3) {
    left = left / right
}

/**
 * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
 * returns the result as a new SCNVector3.
 */
func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / Float(scalar), vector.y / Float(scalar), vector.z / Float(scalar))
}

/**
 * Divides the x, y and z of a SCNVector3 by the same scalar value.
 */
func /= (vector: inout SCNVector3, scalar: Float) {
    vector = vector / scalar
}

/**
 * Negate a vector
 */
func SCNVector3Negate(_ vector: SCNVector3) -> SCNVector3 {
    return vector * -1
}

/**
 * Returns the length (magnitude) of the vector described by the SCNVector3
 */
func SCNVector3Length(_ vector: SCNVector3) -> Float
{
    return sqrtf((Float(vector.x*vector.x) + Float(vector.y*vector.y)) + Float(vector.z*vector.z))
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
func SCNVector3Distance(_ vectorStart: SCNVector3, vectorEnd: SCNVector3) -> Float {
    return SCNVector3Length(vectorEnd - vectorStart)
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
func SCNVector3Normalize(_ vector: SCNVector3) -> SCNVector3 {
    return vector / SCNVector3Length(vector)
}

/**
 * Calculates the dot product between two SCNVector3 vectors
 */
func SCNVector3DotProduct(_ left: SCNVector3, right: SCNVector3) -> Float {
    return Float(((left.x * right.x) + (left.y * right.y)) + (left.z * right.z))
}

/**
 * Calculates the cross product between two SCNVector3 vectors
 */
func SCNVector3CrossProduct(_ left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(((left.y * right.z) - (left.z * right.y)), ((left.z * right.x) - (left.x * right.z)), ((left.x * right.y) - (left.y * right.x)))
}


/**
 * Project the vector, vectorToProject, onto the vector, projectionVector.
 */
func SCNVector3Project(_ vectorToProject: SCNVector3, projectionVector: SCNVector3) -> SCNVector3 {
    let scale: Float = SCNVector3DotProduct(projectionVector, right: vectorToProject) / SCNVector3DotProduct(projectionVector, right: projectionVector)
    let v: SCNVector3 = projectionVector * scale
    return v
}
