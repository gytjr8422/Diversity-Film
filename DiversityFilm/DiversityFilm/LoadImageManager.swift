
import UIKit

struct LoadImageManager {
    let cache = NSCache<NSString, UIImage>()
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> ()) {
        if let url = URL(string: url) {
            // 이미지 캐시 확인
            if let cachedImage = self.cache.object(forKey: url.absoluteString as NSString) {
                completion(cachedImage)
                return
            }
            
            // 이미지 다운로드 및 캐시
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            }.resume()
        }
    }
}
