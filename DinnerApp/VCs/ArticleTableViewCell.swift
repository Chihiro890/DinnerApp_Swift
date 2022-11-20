import UIKit

class ArticleTableViewCell: UITableViewCell {
   

    @IBOutlet weak var titleLabel: UILabel! //①
    @IBOutlet weak var countryAtLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel! //⑤
    @IBOutlet weak var languageLabel: UILabel! //④
    @IBOutlet weak var authorLabel: UILabel! //②
    @IBOutlet weak var detailLabel: UILabel! //②
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

