//
//  ViewController.swift
//  EggTimerApp - Code
//
//  Created by Danila Bolshakov on 19.07.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - UI
    private lazy var mainStackOne: UIStackView = {
        let element = UIStackView()
        //element.backgroundColor = .systemCyan
        element.spacing = 0
        element.distribution = .fillEqually
        element.axis = .vertical
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    private lazy var mainLabelView: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eggStackView: UIStackView = {
        let element = UIStackView()
        //element.backgroundColor = .gray
        element.spacing = 20
        element.distribution = .fillEqually
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var softImageView = UIImageView(imageName: "soft_egg")
    private lazy var mediumImageView = UIImageView(imageName: "medium_egg")
    private lazy var hardImageView = UIImageView(imageName: "hard_egg")
    
    private lazy var softButton = UIButton(name: "Soft")
    private lazy var mediumButton = UIButton(name: "Medium")
    private lazy var hardButton = UIButton(name: "Hard")
   
                
    private lazy var timerView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var progressView: UIProgressView = {
        let element = UIProgressView()
        element.progressTintColor = .systemYellow
        element.trackTintColor = .systemGray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private let eggTimes = ["Soft": 4, "Medium": 420, "Hard": 720]
    private var totalTime = 0
    private var secondPassed = 0
    private var timer = Timer()
    private var player: AVAudioPlayer?
    private var nameSoundTimer = "alarm_sound"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstrains()
        
    }
    
    // MARK: - Business Logic
    private func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return } //путь к url
        player = try! AVAudioPlayer(contentsOf: url) //попробуй запустить player
        player?.play() // player
    }
    
    @objc private func eggsButtonsTapped(_ sender: UIButton) {
        timer.invalidate() //сброс таймера
        progressView.setProgress(0, animated: true) //сбросить progressView
        secondPassed = 0 //секунды для таймера (сброс на ноль)
        
        let hardness = sender.titleLabel?.text ?? "error" //создаем переменную для записи  кнопку
        mainLabelView.text = "You should \(hardness)" //записываем в кнопку
        totalTime = eggTimes[hardness] ?? 0 //вытаскиваем из словаря значение
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true) //активация таймера
    }
    
    @objc private func updateTimer() {
        if secondPassed < totalTime { // проверяем если у нас секунды < общего время из словаря
            secondPassed += 1 // + секунды общие выполнения
            let percentageProgress = Float(secondPassed) / Float(totalTime) //для получения значения в % для progressView
            progressView.setProgress(percentageProgress, animated: true) //передать значение для progressView
        } else {
            playSound(nameSoundTimer) //производим наш звук
            timer.invalidate() //обнуляем таймер
            secondPassed = 0 //обнуляем счетчик секунд
            mainLabelView.text = "That's done! Let's go repeats?" //выводится текст на Label
            progressView.setProgress(0, animated: true)
        }
    }
}

// MARK: - Set Views and Setup Constrains

extension ViewController {
    private func setViews() {
        view.backgroundColor = .systemCyan
        view.addSubview(mainStackOne)
        
        mainStackOne.addArrangedSubview(mainLabelView)
        mainStackOne.addArrangedSubview(eggStackView)
        mainStackOne.addArrangedSubview(timerView)
        
        eggStackView.addArrangedSubview(softImageView)
        eggStackView.addArrangedSubview(mediumImageView)
        eggStackView.addArrangedSubview(hardImageView)
        
        softImageView.addSubview(softButton)
        mediumImageView.addSubview(mediumButton)
        hardImageView.addSubview(hardButton)
        
        softButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        
        
        timerView.addSubview(progressView)
        
    }
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            mainStackOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackOne.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            progressView.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: timerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            
            softButton.topAnchor.constraint(equalTo: softImageView.topAnchor),
            softButton.bottomAnchor.constraint(equalTo: softImageView.bottomAnchor),
            softButton.leadingAnchor.constraint(equalTo: softImageView.leadingAnchor),
            softButton.trailingAnchor.constraint(equalTo: softImageView.trailingAnchor),
            
            mediumButton.topAnchor.constraint(equalTo: mediumImageView.topAnchor),
            mediumButton.bottomAnchor.constraint(equalTo: mediumImageView.bottomAnchor),
            mediumButton.leadingAnchor.constraint(equalTo: mediumImageView.leadingAnchor),
            mediumButton.trailingAnchor.constraint(equalTo: mediumImageView.trailingAnchor),
            
            hardButton.topAnchor.constraint(equalTo: hardImageView.topAnchor),
            hardButton.bottomAnchor.constraint(equalTo: hardImageView.bottomAnchor),
            hardButton.leadingAnchor.constraint(equalTo: hardImageView.leadingAnchor),
            hardButton.trailingAnchor.constraint(equalTo: hardImageView.trailingAnchor)
        ])
    }
}

// MARK: - Extension

extension UIButton {
    convenience init(name: String) {
        self.init(type: .system)
        self.setTitle(name, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        self.tintColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImageView {
    convenience init(imageName: String) {
        self.init()
        self.image = UIImage(named: imageName)
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}




