//
//  Term.swift
//  Shared
//
//  AI 術語數據模型 — App 與 Widget 共用
//

import Foundation

public struct Term: Codable, Identifiable, Hashable {
    public let id: Int
    public let term: String
    public let abbr: String
    public let category: String
    public let definition: String
    public let example: String
    public let related: [String]

    public init(id: Int, term: String, abbr: String, category: String,
                definition: String, example: String, related: [String]) {
        self.id = id
        self.term = term
        self.abbr = abbr
        self.category = category
        self.definition = definition
        self.example = example
        self.related = related
    }
}

public enum GlossaryCategory: String, CaseIterable, Codable {
    case foundations = "foundations"
    case machineLearning = "machine_learning"
    case deepLearning = "deep_learning"
    case nlpLLM = "nlp_llm"
    case computerVision = "computer_vision"
    case generativeAI = "generative_ai"
    case reinforcementLearning = "reinforcement_learning"
    case aiAgents = "ai_agents"
    case aiEngineering = "ai_engineering"
    case dataTraining = "data_training"
    case aiEthicsSafety = "ai_ethics_safety"
    case hardwareCompute = "hardware_compute"
    case multimodal = "multimodal"
    case mathStats = "math_stats"
    case productsTools = "products_tools"
    case robotics = "robotics"

    public var displayName: String {
        switch self {
        case .foundations: return "基礎概念"
        case .machineLearning: return "機器學習"
        case .deepLearning: return "深度學習"
        case .nlpLLM: return "自然語言與LLM"
        case .computerVision: return "電腦視覺"
        case .generativeAI: return "生成式AI"
        case .reinforcementLearning: return "強化學習"
        case .aiAgents: return "AI代理"
        case .aiEngineering: return "AI工程與部署"
        case .dataTraining: return "數據與訓練"
        case .aiEthicsSafety: return "AI倫理與安全"
        case .hardwareCompute: return "硬體與算力"
        case .multimodal: return "多模態"
        case .mathStats: return "數學與統計"
        case .productsTools: return "產品與工具"
        case .robotics: return "機器人"
        }
    }

    public var icon: String {
        switch self {
        case .foundations: return "square.stack.3d.up"
        case .machineLearning: return "cpu"
        case .deepLearning: return "brain.head.profile"
        case .nlpLLM: return "text.bubble"
        case .computerVision: return "eye"
        case .generativeAI: return "wand.and.stars"
        case .reinforcementLearning: return "gamecontroller"
        case .aiAgents: return "person.crop.circle.badge.questionmark"
        case .aiEngineering: return "gearshape.2"
        case .dataTraining: return "chart.bar.doc.horizontal"
        case .aiEthicsSafety: return "shield.lefthalf.filled"
        case .hardwareCompute: return "memorychip"
        case .multimodal: return "rectangle.on.rectangle"
        case .mathStats: return "function"
        case .productsTools: return "wrench.and.screwdriver"
        case .robotics: return "robot"
        }
    }
}
