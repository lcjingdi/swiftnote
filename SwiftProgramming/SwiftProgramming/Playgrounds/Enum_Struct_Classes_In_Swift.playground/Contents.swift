//: Playground - noun: a place where people can play

import Foundation

/*
 枚举1:
 C-style enum
 
enum ColorName {
    case black
    case silver
    case gray
    case white
    case red
}
 */
/*
 枚举2:
 enum ColorName: String {
 case black = "black"
 case silver = "silver"
 case gray = "gray"
 case white = "white"
 case red = "red"
 }
 */
/*
 枚举3:
 跟枚举2一样
 
 enum ColorName: String {
 case black
 case silver
 case gray
 case white
 case red
 }
 */

/*
枚举4:
跟枚举3一样
}
*/
//enum ColorName: String {
//    case black,silver,gray,white,red
//}

enum CSSColor {
    case named(ColorName)
    case rgb(UInt8, UInt8, UInt8)
}

extension CSSColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .named(let colorName):
            return colorName.rawValue
        case .rgb(let red, let green, let blue):
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
}

extension CSSColor {
    init(gray: UInt8) {
        self = .rgb(gray, gray, gray)
    }
}

extension CSSColor {
    enum ColorName: String {
        case black, silver, gray, white, maroon, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
    }
}

enum Math {
    static let phi = 1.6180339887498948482 // golden mean
}


protocol Drawable {
    func draw(with context: DrawingContext)
}
protocol DrawingContext {
    func draw(circle: Circle)
    func draw(rectangle: Rectangle)
}

struct Circle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(.red)
    var fillColor = CSSColor.named(.yellow)
    var center = (x: 80.0, y: 160.0)
    var radius = 60.0
    
    func draw(with context: DrawingContext) {
        context.draw(circle: self)
    }
}

struct Rectangle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(.teal)
    var fillColor = CSSColor.named(.aqua)
    var origin = (x: 110.0, y: 10.0)
    var size = (width: 100.0, height: 130.0)
    
    func draw(with context: DrawingContext) {
        context.draw(rectangle: self)
    }
}

final class SVGContext: DrawingContext {
    private var commands: [String] = []
    
    var width = 250
    var height = 250

    func draw(circle: Circle) {
        commands.append("<circle cx='\(circle.center.x)' cy='\(circle.center.y)\' r='\(circle.radius)' stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' stroke-width='\(circle.strokeWidth)'  />")
    }
    func draw(rectangle: Rectangle) {
        commands.append("<rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' width='\(rectangle.size.width)' height='\(rectangle.size.height)' stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' stroke-width='\(rectangle.strokeWidth)' />")
    }
    
    var svgString: String {
        var output = "<svg width='\(width)' height='\(height)'>"
        for command in commands {
            output += command
        }
        output += "</svg>"
        return output
    }
    var htmlString: String {
        return "<!DOCTYPE html><html><body>" + svgString + "</body></html>"
    }
}

struct SVGDocument {
    var drawables: [Drawable] = []
    
    var htmlString: String {
        let context = SVGContext()
        for drawable in drawables {
            drawable.draw(with: context)
        }
        return context.htmlString
    }
    
    mutating func append(_ drawable: Drawable) {
        drawables.append(drawable)
    }
}

var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)

import WebKit
import PlaygroundSupport

let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view

extension Circle {
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }
    var area: Double {
        return radius * radius * Double.pi
    }
    var perimeter: Double {
        return 2 * radius * Double.pi
    }
    
    mutating func shift(x: Double, y: Double) {
        center.x += x
        center.y += y
    }
}


