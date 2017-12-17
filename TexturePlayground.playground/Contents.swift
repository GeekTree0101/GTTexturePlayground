//: Playground - noun: a place where people can play

import UIKit
import AsyncDisplayKit
import SnapKit
import PlaygroundSupport

class viewController: UIViewController {
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode.init(style: .plain)
        node.dataSource = self
        return node
    }()

    let textNode = TestNode()
    let node = ASDisplayNode()
    
    struct Const {
        static let textNodeInsets = UIEdgeInsets.init(top: .infinity,
                                                      left: 20.0,
                                                      bottom: 20.0,
                                                      right: 20.0)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.preferredContentSize = CGSize.init(width: 300, height: 300)
        
        self.view.addSubnode(node)
        self.node.onDidLoad({ node in
            node.backgroundColor = .white
            node.view.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        })
        
        
        self.node.layoutSpecBlock = { (node, _) -> ASLayoutSpec in
            let insetsTextNode = ASInsetLayoutSpec
                .init(insets: Const.textNodeInsets,
                      child: self.textNode)
            
            let insetsTableNode = ASInsetLayoutSpec
                .init(insets: .zero,
                      child: self.tableNode)
            
            let overlayFloatingNode = ASOverlayLayoutSpec
                .init(child: insetsTableNode,
                      overlay: insetsTextNode)
            
            return overlayFloatingNode
        }
        
        
        self.node.automaticallyManagesSubnodes = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension viewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASCellNode.init()
        cell.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        cell.style.preferredSize = CGSize.init(width: UIScreen.main.bounds.width, height: 80.0)
        return cell
    }
}

class TestNode: ASDisplayNode {
    
    let titleNode = ASTextNode()
    let subTitleNode = ASTextNode()
    let touchEventNode = ASControlNode()
    var didTap: Bool = false
    
    override init() {
        super.init()
        self.backgroundColor = .black
        titleNode.attributedText =
            self.attributedText("Floating Node", size: 20.0)
        
        self.titleNode.style.height = .init(unit: .points, value: 100.0)
        subTitleNode.attributedText =
            self.attributedText("description: floating node test", size: 13.0)
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 0.0,
                                      justifyContent: .start,
                                      alignItems: .center,
                                      children: [titleNode, subTitleNode])
        
        return ASOverlayLayoutSpec
            .init(child: stack,
                  overlay: touchEventNode)
    }
    
    override func didLoad() {
        super.didLoad()
        self.touchEventNode.addTarget(self,
                                      action: #selector(touch),
                                      forControlEvents: .touchUpInside)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.titleNode.style.height =
                .init(unit: .points,
                      value: self.didTap ? 50.0: 100.0)
            self.titleNode.alpha = self.didTap ? 0.5: 1.0
            self.titleNode.setNeedsLayout()
        }, completion: { fin in
            context.completeTransition(fin)
        })
        
        super.animateLayoutTransition(context)
    }
    
    @objc func touch() {
        self.didTap = !self.didTap
        self.transitionLayout(withAnimation: true,
                              shouldMeasureAsync: true,
                              measurementCompletion: nil)
    }
    
    private func attributedText(_ text: String, size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)])
    }
    
    
}



PlaygroundPage.current.liveView = viewController()
