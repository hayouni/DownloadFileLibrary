import UIKit

public extension UITableView {
    
    func registerNibCell<T: UITableViewCell>(ofType type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(ofType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot create reusable cell with type \(String(describing: self))). Did you register the cell for the table view? Did you set the cell identifier right?")
        }
        return cell
    }
    
}

public extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

 public class NibView: UIView {
    open var nibName: String { String(describing: type(of: self)) }
    
    public init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    open func setupView() {
        let view = viewFromNib()
        
        // Show the view.
        insertSubview(view, at: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
 
    func viewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        // swiftlint:disable force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}

public extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
