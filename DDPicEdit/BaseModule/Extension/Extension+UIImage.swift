//
//  Extension+UIImage.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/18.
//

import UIKit
import CoreImage

extension UIImage {
    
    /// 生成马赛克图片
    /// 在 DEBUG 模式下耗时 1-3 秒左右，RELEASE 模式下耗时 0.02 秒左右
    /// - Parameter level: 一个点转为多少 level*level 的正方形
    func mosaicImage(level: Int) -> UIImage? {
        // 获取 BitmapData
        let pixelChannelCount = 4
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let imgRef = self.cgImage else { return nil }
        let width = imgRef.width
        let height = imgRef.height
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: width*pixelChannelCount,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        context?.draw(imgRef, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        guard let bitmapData = context?.data else { return nil }
        
        //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
        var pixel: [UInt8] = Array(repeating: 0, count: pixelChannelCount)
        var index = 0
        var preIndex = 0
        for i in 0..<height-1 {
            for j in 0..<width-1 {
                index = i * width + j
                if i % level == 0 {
                    if j % level == 0 {
                        memcpy(&pixel, bitmapData + pixelChannelCount * index, pixelChannelCount)
                    } else {
                        memcpy(bitmapData + pixelChannelCount * index, &pixel, pixelChannelCount)
                    }
                } else {
                    preIndex = (i-1) * width + j
                    memcpy(bitmapData + pixelChannelCount * index, bitmapData + pixelChannelCount * preIndex, pixelChannelCount)
                }
            }
        }
        let dataLength = width * height * pixelChannelCount
        let providerOptional = CGDataProvider(dataInfo: nil, data: bitmapData, size: dataLength) { (_, _, _) in
        }
        guard let provider = providerOptional else { return nil }

        // 创建要输出的图像
        guard let mosaicImageRef =
            CGImage(width: width,
                    height: height,
                    bitsPerComponent: bitsPerComponent,
                    bitsPerPixel: 32,
                    bytesPerRow: width * pixelChannelCount,
                    space: colorSpace,
                    bitmapInfo: CGBitmapInfo(rawValue: 1),
                    provider: provider,
                    decode: nil,
                    shouldInterpolate: false,
                    intent: .defaultIntent)
            else { return nil }
        let outputContext = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: width * pixelChannelCount,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        outputContext?.draw(mosaicImageRef, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        guard let resultImageRef = outputContext?.makeImage() else { return nil }
        let scale = UIScreen.main.scale
        let resultImage = UIImage(cgImage: resultImageRef, scale: scale, orientation: .up)
        return resultImage
    }
    
    /// 高斯模糊图像
    /// - Parameter context: 上下文
    /// - Parameter blur: 模糊度
    func gaussianImage(blur: CGFloat) -> UIImage? {
        guard let filter = CIFilter(name: "CIGaussianBlur") else { return nil }
        return self.generateImageByCIFilter(filter: filter) {
            filter.setValue(blur, forKey: "inputRadius")
        }
    }
    
    // brightness: 0-1  saturation: 0-2 contrast: 0-4
    func editImage(brightness: CGFloat, saturation: CGFloat, contrast: CGFloat) -> UIImage? {
        guard let filter = CIFilter(name: "CIColorControls") else { return nil }
        return self.generateImageByCIFilter(filter: filter) {
            filter.setValue(brightness, forKey: "inputSaturation")
            filter.setValue(brightness, forKey: "inputBrightness")
            filter.setValue(contrast, forKey: "inputContrast")
        }
    }
    
    func drawWaterMark(attr: NSAttributedString, point: CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        // 将这个pic绘制在Context中
        self.draw(at: .zero)
        // pic绘制str
        attr.draw(at: point)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func generateImageByCIFilter(filter: CIFilter, _ configFilterBlock: Block) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        configFilterBlock()
        guard let result = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        guard let outputImage = CIContext().createCGImage(result, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: outputImage)
    }
    
    /// 截取图片的指定区域，并生成新图片
    /// - Parameter rect: 指定的区域
    func cropping(to rect: CGRect) -> UIImage? {
        // 截取部分图片并生成新图片
        guard let sourceImageRef = self.cgImage else { return nil }
        guard let newImageRef = sourceImageRef.cropping(to: rect) else { return nil }
        let newImage = UIImage(cgImage: newImageRef, scale: 1, orientation: .up)
        return newImage
    }
}
