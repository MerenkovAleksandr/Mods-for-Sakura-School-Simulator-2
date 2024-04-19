//  Created by Systems
//


import UIKit



protocol AnimatedButtonEvent_MTW : AnyObject {
    func onClick_MTW()
}

enum animationButtonStyle_MTW {
    case gif,native
}

class AnimatedButton_MTW: UIView {
    
    
    @IBOutlet private var contentSelf: UIView!
    @IBOutlet private weak var backgroundSelf: UIImageView!
    @IBOutlet private weak var titleSelf: UILabel!
    
    weak var delegate : AnimatedButtonEvent_MTW?
    private let currentFont = "SFProText-Bold"
    private var persistentAnimations: [String: CAAnimation] = [:]
    private var persistentSpeed: Float = 0.0
    private let xib = "AnimatedButton_MTW"
    
    public var style : animationButtonStyle_MTW = .native
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Init_MTW()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Init_MTW()
    }
    
    // Этот метод будет вызван, когда view добавляется к superview
      override func didMoveToSuperview() {
          super.didMoveToSuperview()
          var _MTW = "_MTW"
          for i in _MTW {
              if i == "d" {
                  _MTW += "d"
              } else {
                  _MTW += "s"
              }
          }
          if style == .native {
              setPulseAnimation_MTW()
              addNotificationObservers_MTW()
          }
        
      }

      // Этот метод будет вызван перед тем, как view будет удален из superview
      override func willMove(toSuperview newSuperview: UIView?) {
          super.willMove(toSuperview: newSuperview)
          var _MTW = "_MTW"
          for i in _MTW {
              if i == "d" {
                  _MTW += "d"
              } else {
                  _MTW += "s"
              }
          }
          if style == .native {
              if newSuperview == nil {
                  self.layer.removeAllAnimations()
                  removeNotificationObservers_MTW()
              }
          }
      }

      private func addNotificationObservers_MTW() {
          var _MTW = "_MTW"
          for i in _MTW {
              if i == "d" {
                  _MTW += "d"
              } else {
                  _MTW += "s"
              }
          }
          NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation_MTW), name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation_MTW), name: UIApplication.willEnterForegroundNotification, object: nil)
      }

      private func removeNotificationObservers_MTW() {
          var _MTW = "_MTW"
          for i in _MTW {
              if i == "d" {
                  _MTW += "d"
              } else {
                  _MTW += "s"
              }
          }
          NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
      }

      @objc private func pauseAnimation_MTW() {
          var _MTW = "_MTW"
          for i in _MTW {
              if i == "d" {
                  _MTW += "d"
              } else {
                  _MTW += "s"
              }
          }
          self.persistentSpeed = self.layer.speed

          self.layer.speed = 1.0 //in case layer was paused from outside, set speed to 1.0 to get all animations
          self.persistAnimations_MTW(withKeys: self.layer.animationKeys())
          self.layer.speed = self.persistentSpeed //restore original speed

          self.layer.pause()
      }

      @objc private func resumeAnimation_MTW() {
          var _MTW = "_MTW"
          for i in _MTW {
              if i == "d" {
                  _MTW += "d"
              } else {
                  _MTW += "s"
              }
          }
          self.restoreAnimations_MTW(withKeys: Array(self.persistentAnimations.keys))
          self.persistentAnimations.removeAll()
          if self.persistentSpeed == 1.0 { //if layer was plaiyng before backgorund, resume it
              self.layer.resume()
          }
      }
    
    func persistAnimations_MTW(withKeys: [String]?) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        withKeys?.forEach({ (key) in
            if let animation = self.layer.animation(forKey: key) {
                self.persistentAnimations[key] = animation
            }
        })
    }

    func restoreAnimations_MTW(withKeys: [String]?) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        withKeys?.forEach { key in
            if let persistentAnimation = self.persistentAnimations[key] {
                self.layer.add(persistentAnimation, forKey: key)
            }
        }
    }
    
    private func Init_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        contentSelf.fixInView_MTW(self)
        contentSelf.backgroundColor = .black
        contentSelf.layer.cornerRadius = 8
        animationBackgroundInit_MTW()
        
    }
    
    private func animationBackgroundInit_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        titleSelf.text = localizedString_MTW(forKey: "iOSButtonID")
        titleSelf.font = UIFont(name: currentFont, size: 29)
        titleSelf.textColor = .white
        titleSelf.minimumScaleFactor = 11/22
        if style == .native {
           setPulseAnimation_MTW()
        }else {
            do {
                let gif = try UIImage(gifName: "btn_gif.gif")
                backgroundSelf.setGifImage(gif)
            } catch {
                print(error)
            }
        }
        
        self.onClick_MTW(target: self, #selector(click))
    }
    
    @objc func click(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        delegate?.onClick_MTW()
    }
    

    
}

extension UIView {
    func setPulseAnimation_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.toValue = 0.95
        pulseAnimation.fromValue = 0.79
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        self.layer.add(pulseAnimation, forKey: "pulse")
    }
}


extension CALayer {
    func pause() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if self.isPaused() == false {
            let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
            self.speed = 0.0
            self.timeOffset = pausedTime
        }
    }

    func isPaused() -> Bool {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        return self.speed == 0.0
    }

    func resume() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
