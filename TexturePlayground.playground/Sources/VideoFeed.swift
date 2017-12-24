//: Playground - noun: a place where people can play

import UIKit
import AsyncDisplayKit
import SnapKit
import PlaygroundSupport

class VideoFeedViewController: UIViewController {
    
    let tableNode = ASTableNode(style: .plain)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableNode.backgroundColor = .gray
        self.view.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.onDidLoad({ _ in
            self.tableNode.view.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableNode.reloadData()
    }
}

extension VideoFeedViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        return VideoTestCellNode()
    }
}

class VideoTestCellNode: ASCellNode {
    
    lazy var videoNode = VideoTestNode()
    
    let insets: UIEdgeInsets = .init(top: 20.0, left: 15.0, bottom: 0.0, right: 15.0)
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: insets, child: videoNode)
    }
}

class VideoTestNode: ASDisplayNode {
    lazy var videoNode = { () -> ASVideoNode in
        let node = ASVideoNode()
        node.backgroundColor = .blue
        node.shouldAutoplay = false
        node.shouldAutorepeat = false
        node.muted = true
        node.delegate = self
        return node
    }()
    
    lazy var titleNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.backgroundColor = .yellow
        node.maximumNumberOfLines = 2
        return node
    }()
    
    lazy var timeAgoNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.backgroundColor = .green
        node.maximumNumberOfLines = 1
        return node
    }()
    
    enum TextStyle {
        case title
        case timeAgo
        
        var fontStyle: UIFont {
            switch self {
            case .title: return UIFont.systemFont(ofSize: 14.0,
                                                  weight: UIFont.Weight.bold)
            case .timeAgo: return UIFont.systemFont(ofSize: 10.0,
                                                    weight: UIFont.Weight.regular)
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .title: return UIColor.black
            case .timeAgo: return UIColor.gray
            }
        }
        
        func attributedText(_ text: String) -> NSAttributedString {
            return NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: self.fontColor, NSAttributedStringKey.font: self.fontStyle])
        }
    }
    
    override init() {
        super.init()
        self.backgroundColor = .white
        self.applyAttribute()
        self.automaticallyManagesSubnodes = true
    }
    
    func applyAttribute() {
        self.videoNode.asset = AVAsset(url: URL(string: "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8")!)
        self.titleNode.attributedText = TextStyle.title.attributedText("VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_VIDEO_TEST_")
        self.timeAgoNode.attributedText = TextStyle.timeAgo.attributedText("2017/12/23")
    }
    
    func videoRatioLayout() -> ASLayoutSpec {
        return ASRatioLayoutSpec(ratio: 0.5, child: self.videoNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 2.0,
                                                justifyContent: .start,
                                                alignItems: .stretch,
                                                children: [videoRatioLayout(),
                                                           titleNode,
                                                           timeAgoNode])
        return ASInsetLayoutSpec(insets: .init(top: 20.0,
                                               left: 15.0,
                                               bottom: 20.0,
                                               right: 15.0),
                                 child: stackLayoutSpec)
    }
}


extension VideoTestNode {
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        self.videoNode.play()
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        self.videoNode.pause()
    }
}

extension VideoTestNode: ASVideoNodeDelegate {
    func videoNodeDidStartInitialLoading(_ videoNode: ASVideoNode) {
        print("DEBUG* InitialLoading")
    }
}

