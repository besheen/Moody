//
//  MoodTableViewCell.swift
//  Moody
//
//  Created by Carl on 2022/8/15.
//

import UIKit
import SnapKit

class MoodTableViewCell: UITableViewCell {
    var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = UIView.ContentMode.scaleAspectFill
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.titleLabel)
        self.iconImageView.snp.makeConstraints { make in
            make.height.equalTo(self.contentView)
            make.width.equalTo(self.contentView.snp.height)
            make.left.equalTo(self.contentView)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.doesRelativeDateFormatting = true
    formatter.formattingContext = .standalone
    return formatter
}()

extension MoodTableViewCell {
    func configure(for mood: Mood) {
        iconImageView.image = UIImage(data: mood.imageData)
        titleLabel.text = dateFormatter.string(from: mood.date)
    }
}
