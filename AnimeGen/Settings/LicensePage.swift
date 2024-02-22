//
//  LicensePage.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import SwiftUI

struct LicensePage: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text("""
                        Copyright © 2023-2024 cranci. All rights reserved.

                        AnimeGen is free software: you can redistribute it and/or modify
                        it under the terms of the GNU General Public License as published by
                        the Free Software Foundation, either version 3 of the License, or
                        (at your option) any later version.

                        AnimeGen is distributed in the hope that it will be useful,
                        but WITHOUT ANY WARRANTY; without even the implied warranty of
                        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                        GNU General Public License for more details.

                        You should have received a copy of the GNU General Public License
                        along with AnimeGen.  If not, see <http://www.gnu.org/licenses/>.
                        """)
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .navigationBarTitle("App License Agreement", displayMode: .large)
    }
}

struct LicensePage_Previews: PreviewProvider {
    static var previews: some View {
        LicensePage()
    }
}
