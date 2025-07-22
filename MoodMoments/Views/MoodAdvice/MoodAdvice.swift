//
//  MoodAdvice.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import Foundation

struct MoodAdvice {
    static func advice(for mood: Int) -> String {
        let tips: [String]
        
        switch mood {
        case 1:
            tips = [
                "🌧 Versuch einen Spaziergang an der frischen Luft.",
                "📝 Schreib deine Gedanken auf – das kann entlasten.",
                "🎧 Höre beruhigende Musik und atme bewusst tief ein.",
                "📵 Gönn dir eine Auszeit vom Handy für 30 Minuten.",
                "💧 Trinke ein Glas Wasser und mach kurz die Augen zu."
            ]
        case 2:
            tips = [
                "📞 Ruf jemanden an, der dir guttut.",
                "😴 Gönn dir 10 Minuten Ruhe ohne Ablenkung.",
                "📖 Lies ein paar Seiten in deinem Lieblingsbuch.",
                "🚿 Eine warme Dusche kann Wunder wirken.",
                "🎨 Versuch etwas Kreatives – malen, schreiben oder Musik."
            ]
        case 3:
            tips = [
                "🧘 Starte eine kleine Atem- oder Achtsamkeitsübung.",
                "🍵 Mach dir einen Tee und beobachte bewusst deine Gedanken.",
                "🌱 Plane etwas Schönes für den Abend oder morgen.",
                "📅 Schau, was dir heute noch Freude machen könnte.",
                "🙌 Feiere kleine Erfolge, auch wenn es nur Aufstehen war."
            ]
        case 4:
            tips = [
                "🎯 Setz dir ein Mini-Ziel, das dir wichtig ist.",
                "✨ Teile deine gute Stimmung mit jemandem.",
                "🎶 Hör dein Lieblingslied und tanz ein bisschen dazu.",
                "📝 Schreib auf, was heute gut gelaufen ist.",
                "🤗 Mach jemand anderem eine kleine Freude."
            ]
        case 5:
            tips = [
                "🌈 Genieße den Moment – du hast es dir verdient!",
                "🎉 Feier deine gute Laune – egal wie klein der Anlass.",
                "📸 Mach ein Foto von etwas, das du heute liebst.",
                "🏞 Mach etwas draußen – dein Energielevel ist top.",
                "🚀 Nutze die Motivation für etwas Neues."
            ]
        default:
            tips = ["🤔 Keine Tipps verfügbar."]
        }
        
        return tips.randomElement() ?? "🌟 Heute ist ein guter Tag für Selbstfürsorge."
    }
}
