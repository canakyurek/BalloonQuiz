//
//  Game+CoachMarksDataSource.swift
//  Balloon
//
//  Created by Can Akyurek on 27.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import Instructions

extension GameViewController: CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int,
                              madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)
        
        coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "Bu koridor senin balonunun için. Balon yere değerse oyun biter."
        case 1:
            coachViews.bodyView.hintLabel.text = "Karşılığını bulacağın kelime burada çıkar"
        case 2:
            coachViews.bodyView.hintLabel.text = "Bu cevaplardan doğru olanı seçmelisin"
        default:
            break
            
        }
        coachViews.bodyView.nextLabel.text = "Tamam"
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: balloonCorridorView)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: questionLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: choiceContainer)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
}

extension GameViewController: CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        self.sceneView.isPaused = false
    }
}
