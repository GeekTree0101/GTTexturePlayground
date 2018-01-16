//: Playground - noun: a place where people can play

import UIKit
import AsyncDisplayKit
import SnapKit
import PlaygroundSupport

class UITestViewController: UIViewController {
    
    let tableNode = ASTableNode(style: .plain)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableNode.backgroundColor = .black
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

extension UITestViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASCellNode()
        cell.backgroundColor = .white
        cell.style.height = .init(unit: .points, value: 100)
        return cell
    }
}


PlaygroundPage.current.liveView = UITestViewController()
