//
//  Vertex.swift
//  Comp8051
//
//  Created by Paul on 2019-02-13.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit

enum VertexAttributes : GLuint {
    case position = 0
    case color = 1
}


struct Vertex {
    var x: GLfloat
    var y: GLfloat
    var z: GLfloat
    var r: GLfloat
    var g: GLfloat
    var b: GLfloat
    var a: GLfloat
}
