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
                "💧 Trinke ein Glas Wasser und mach kurz die Augen zu.",
                "🛁 Nimm ein warmes Bad, um dich zu entspannen.",
                "🌿 Verbringe Zeit in der Natur, wenn möglich.",
                "📺 Schau eine Lieblingsserie oder einen Film zur Ablenkung.",
                "🧩 Beschäftige dich mit einem Puzzle oder einem ruhigen Spiel.",
                "🤗 Sprich mit einer vertrauten Person über deine Gefühle."
            ]
        case 2:
            tips = [
                "📞 Ruf jemanden an, der dir guttut.",
                "😴 Gönn dir 10 Minuten Ruhe ohne Ablenkung.",
                "📖 Lies ein paar Seiten in deinem Lieblingsbuch.",
                "🚿 Eine warme Dusche kann Wunder wirken.",
                "🎨 Versuch etwas Kreatives – malen, schreiben oder Musik.",
                "🌸 Mach eine kleine Meditation oder Atemübung.",
                "🍽 Bereite dir eine kleine gesunde Mahlzeit zu.",
                "🎬 Schau einen inspirierenden Kurzfilm oder TED Talk.",
                "📅 Plane eine kleine Aktivität für morgen.",
                "🧦 Mach deine Lieblingskuschelsocken an und entspanne."
            ]
        case 3:
            tips = [
                "🧘 Starte eine kleine Atem- oder Achtsamkeitsübung.",
                "🍵 Mach dir einen Tee und beobachte bewusst deine Gedanken.",
                "🌱 Plane etwas Schönes für den Abend oder morgen.",
                "📅 Schau, was dir heute noch Freude machen könnte.",
                "🙌 Feiere kleine Erfolge, auch wenn es nur Aufstehen war.",
                "🎧 Höre einen Podcast, der dich interessiert oder motiviert.",
                "🖼 Schau dir inspirierende Bilder oder Zitate an.",
                "🚶‍♂️ Mach einen kurzen Spaziergang, um den Kopf frei zu bekommen.",
                "✍️ Schreib eine kurze To-Do-Liste mit erreichbaren Zielen.",
                "📚 Lies ein Kapitel in einem inspirierenden Buch."
            ]
        case 4:
            tips = [
                "🎯 Setz dir ein Mini-Ziel, das dir wichtig ist.",
                "✨ Teile deine gute Stimmung mit jemandem.",
                "🎶 Hör dein Lieblingslied und tanz ein bisschen dazu.",
                "📝 Schreib auf, was heute gut gelaufen ist.",
                "🤗 Mach jemand anderem eine kleine Freude.",
                "📸 Mach ein paar Fotos von schönen Momenten heute.",
                "🌞 Verbringe Zeit draußen, wenn möglich.",
                "📅 Plane eine kleine Belohnung für dich selbst.",
                "🎮 Spiel ein Lieblingsspiel oder probiere etwas Neues.",
                "🧩 Starte ein neues kreatives Projekt oder Hobby."
            ]
        case 5:
            tips = [
                "🌈 Genieße den Moment – du hast es dir verdient!",
                "🎉 Feier deine gute Laune – egal wie klein der Anlass.",
                "📸 Mach ein Foto von etwas, das du heute liebst.",
                "🏞 Mach etwas draußen – dein Energielevel ist top.",
                "🚀 Nutze die Motivation für etwas Neues.",
                "💪 Teile deine Energie mit anderen und unterstütze sie.",
                "🧠 Lerne etwas Neues, das dich interessiert.",
                "🎤 Sing laut dein Lieblingslied mit – Spaß garantiert!",
                "🤝 Verabrede dich mit Freunden oder Familie.",
                "📝 Schreib deine Ziele und Visionen auf, um sie zu verfolgen."
            ]
        default:
            tips = ["🤔 Keine Tipps verfügbar."]
        }
        
        return tips.randomElement() ?? "🌟 Heute ist ein guter Tag für Selbstfürsorge."
    }
}
