unit BodiesInfo;

interface

uses
  Graphics;

type
  TBodyDrawInfo = record
    Color1:     TColor;
    Color2:     TColor;
    Color3:     TColor;
    ZoomRadius: Extended;
  end;

  TBodyInfo = record
    Name:                 String;
    Mass:                 Extended; (* [kg] *)
    ReducedMass:          Extended; (* 10^+11 [kg] *)
    Radius:               Extended; (* [m] *)
    Periapsis:            Extended; (* [m] *)
    Apoapsis:             Extended; (* [m] *)
    SemiMajorAxis:        Extended; (* [m] *)
    Eccentricity:         Extended;
    Inclination:          Extended; (* [deg] *) 
    OrbitalPeriod:        Extended; (* sidereal [s] *)
    PeAOrbitalVelocity:   Extended; (* [m/s] *)
    ApAOrbitalVelocity:   Extended; (* [m/s] *)
    MeanOrbitalVelocity:  Extended; (* [m/s] *)
    DrawInfo:             TBodyDrawInfo;
  end;
  PBodyInfo = ^TBodyInfo;

const
(*
Source: http://nssdc.gsfc.nasa.gov/planetary/planetfact.html
*)

//--- Sun ----------------------------------------------------------------------

  cSunInfo: TBodyInfo = (
    Name:                 'Sun';
    Mass:                 1.9885e30;
    ReducedMass:          1.9885e19;
    Radius:               6.96e8;
    Periapsis:            0;
    Apoapsis:             0;
    SemiMajorAxis:        0;
    Eccentricity:         0;
    Inclination:          0;  
    OrbitalPeriod:        0;  
    PeAOrbitalVelocity:   0;
    ApAOrbitalVelocity:   0;
    MeanOrbitalVelocity:  0;
    DrawInfo: (
      Color1:     $00E8FFFF;
      Color2:     clYellow;
      Color3:     $0000A8A8;
      ZoomRadius: 10000000000;
    );
  );

//--- Mercury ------------------------------------------------------------------

  cMercuryInfo: TBodyInfo = (
    Name:                 'Mercury';
    Mass:                 3.301e23;
    ReducedMass:          3.301e12;
    Radius:               2439700;
    Periapsis:            46000000000;
    Apoapsis:             69820000000;
    SemiMajorAxis:        57910000000;
    Eccentricity:         0.2056;
    Inclination:          7;
    OrbitalPeriod:        7600522;
    PeAOrbitalVelocity:   58980;
    ApAOrbitalVelocity:   38860;
    MeanOrbitalVelocity:  47360;
    DrawInfo: (
      Color1:     $00D9E6EA;
      Color2:     $004D7E8C;
      Color3:     $002B454D;
      ZoomRadius: 50000000;
    );
  );

//--- Venus --------------------------------------------------------------------

  cVenusInfo: TBodyInfo = (
    Name:                 'Venus';
    Mass:                 4.8676e24;
    ReducedMass:          4.8676e13;
    Radius:               6051800;
    Periapsis:            107480000000;
    Apoapsis:             108940000000;
    SemiMajorAxis:        108210000000;
    Eccentricity:         0.0067;
    Inclination:          3.39;
    OrbitalPeriod:        19414166;
    PeAOrbitalVelocity:   35260;
    ApAOrbitalVelocity:   34790;
    MeanOrbitalVelocity:  35020;
    DrawInfo: (
      Color1:     $00BDF4F1;
      Color2:     $0021C0B9;
      Color3:     $0018928B;
      ZoomRadius: 50000000;
    );
  );

//--- Earth --------------------------------------------------------------------

  cEarthInfo: TBodyInfo = (
    Name:                 'Earth';
    Mass:                 5.9726e24;
    ReducedMass:          5.9726e13;
    Radius:               6378100;
    Periapsis:            147090000000;
    Apoapsis:             152100000000;
    SemiMajorAxis:        149600000000;
    Eccentricity:         0.0167;
    Inclination:          0;
    OrbitalPeriod:        31558118;
    PeAOrbitalVelocity:   30290;
    ApAOrbitalVelocity:   29290;
    MeanOrbitalVelocity:  29780;
    DrawInfo: (
      Color1:     $00FFDFDF;
      Color2:     clBlue;
      Color3:     $00910000;
      ZoomRadius: 50000000;
    );
  );

//--- Moon ---------------------------------------------------------------------

  cMoonInfo: TBodyInfo = (
    Name:                 'Moon';
    Mass:                 7.342e22;
    ReducedMass:          7.342e11;
    Radius:               1738100;
    Periapsis:            363300000;
    Apoapsis:             405500000;
    SemiMajorAxis:        384400000;
    Eccentricity:         0.0549;
    Inclination:          5.145;
    OrbitalPeriod:        2360595;
    PeAOrbitalVelocity:   1076;
    ApAOrbitalVelocity:   964;
    MeanOrbitalVelocity:  1022;
    DrawInfo: (
      Color1:     $00E6E6E6;
      Color2:     clGray;
      Color3:     $00656565;
      ZoomRadius: 50000000;
    );
  );

//--- Mars ---------------------------------------------------------------------

  cMarsInfo: TBodyInfo = (
    Name:                 'Mars';
    Mass:                 6.4174e23;
    ReducedMass:          6.4174e12;
    Radius:               3396200;
    Periapsis:            206620000000;
    Apoapsis:             249230000000;
    SemiMajorAxis:        227920000000;
    Eccentricity:         0.0935;
    Inclination:          1.850;
    OrbitalPeriod:        59355072;
    PeAOrbitalVelocity:   26500;
    ApAOrbitalVelocity:   21970;
    MeanOrbitalVelocity:  24070;
    DrawInfo: (
      Color1:     $00DDDDFF;
      Color2:     $000000D9;
      Color3:     $00000079;
      ZoomRadius: 50000000;
    );
  );

//--- Phobos -------------------------------------------------------------------

  cPhobosInfo: TBodyInfo = (
    Name:                 'Phobos';
    Mass:                 1.06E16;
    ReducedMass:          106000;
    Radius:               11200;
    Periapsis:            9236000;
    Apoapsis:             9519000;
    SemiMajorAxis:        9378000;
    Eccentricity:         0.0151;
    Inclination:          1.08;
    OrbitalPeriod:        27574;
    PeAOrbitalVelocity:   2169;
    ApAOrbitalVelocity:   2104;
    MeanOrbitalVelocity:  2136;
    DrawInfo: (
      Color1:     $00EBE7E9;
      Color2:     $007B6470;
      Color3:     $00473A41;
      ZoomRadius: 50000;
    );
  );

//--- Deimos -------------------------------------------------------------------

  cDeimosInfo: TBodyInfo = (
    Name:                 'Deimos';
    Mass:                 2.4E15;
    ReducedMass:          24000;
    Radius:               6100;
    Periapsis:            23447000;
    Apoapsis:             23470000;
    SemiMajorAxis:        23459000;
    Eccentricity:         0.0005;
    Inclination:          1.79;
    OrbitalPeriod:        109094;
    PeAOrbitalVelocity:   1352;
    ApAOrbitalVelocity:   1350;
    MeanOrbitalVelocity:  1351;
    DrawInfo: (
      Color1:     $00D3E7F8;
      Color2:     $001E74C1;
      Color3:     $0011416C;
      ZoomRadius: 50000;
    );
  );

//--- Jupiter ------------------------------------------------------------------

  cJupiterInfo: TBodyInfo = (
    Name:                 'Jupiter';
    Mass:                 1898.3e24;
    ReducedMass:          1898.3e13;
    Radius:               71492000;
    Periapsis:            740520000000;
    Apoapsis:             816620000000;
    SemiMajorAxis:        778570000000;
    Eccentricity:         0.0489;
    Inclination:          1.304;
    OrbitalPeriod:        374335690;
    PeAOrbitalVelocity:   13720;
    ApAOrbitalVelocity:   12440;
    MeanOrbitalVelocity:  13060;
    DrawInfo: (
      Color1:     $00C4E1FF;
      Color2:     $000080FF;
      Color3:     $000055AA;
      ZoomRadius: 200000000;
    );
  );

//--- Io -----------------------------------------------------------------------

  cIoInfo: TBodyInfo = (
    Name:                 'Io';
    Mass:                 893.2e20;
    ReducedMass:          893.2e9;
    Radius:               1821600;
    Periapsis:            419900000;
    Apoapsis:             423300000;
    SemiMajorAxis:        421600000;
    Eccentricity:         0.004;
    Inclination:          0.04;
    OrbitalPeriod:        152854;
    PeAOrbitalVelocity:   17403;
    ApAOrbitalVelocity:   17265;
    MeanOrbitalVelocity:  17334;
    DrawInfo: (
      Color1:     $00BFFFFF;
      Color2:     $0000FFFF;
      Color3:     $0000B0B0;
      ZoomRadius: 20000000;
    );
  );

//--- Europa -------------------------------------------------------------------

  cEuropaInfo: TBodyInfo = (
    Name:                 'Europa';
    Mass:                 480e20;
    ReducedMass:          480e9;
    Radius:               1560800;
    Periapsis:            664120000;
    Apoapsis:             677680000;
    SemiMajorAxis:        670900000;
    Eccentricity:         0.0101;
    Inclination:          0.47;
    OrbitalPeriod:        306777;
    PeAOrbitalVelocity:   13880;
    ApAOrbitalVelocity:   13602;
    MeanOrbitalVelocity:  13740;
    DrawInfo: (
      Color1:     $00FCFAC9;
      Color2:     $00F3E80C;
      Color3:     $00AEA609;
      ZoomRadius: 20000000;
    );
  );

//--- Ganymede -----------------------------------------------------------------

  cGanymedeInfo: TBodyInfo = (
    Name:                 'Ganymede';
    Mass:                 1481.9e20;
    ReducedMass:          1481.9e9;
    Radius:               2631200;
    Periapsis:            1068800000;
    Apoapsis:             1072000000;
    SemiMajorAxis:        1070400000;
    Eccentricity:         0.0015;
    Inclination:          0.21;
    OrbitalPeriod:        618238;
    PeAOrbitalVelocity:   10895;
    ApAOrbitalVelocity:   10862;
    MeanOrbitalVelocity:  10879;
    DrawInfo: (
      Color1:     $00CDD1CD;
      Color2:     $007B857A;
      Color3:     $00525751;
      ZoomRadius: 20000000;
    );
  );

//--- Callisto -----------------------------------------------------------------

  cCallistoInfo: TBodyInfo = (
    Name:                 'Callisto';
    Mass:                 1075.9e20;
    ReducedMass:          1075.9e9;
    Radius:               2410300;
    Periapsis:            1869500000;
    Apoapsis:             1895900000;
    SemiMajorAxis:        1882700000;
    Eccentricity:         0.007;
    Inclination:          0.51;
    OrbitalPeriod:        1442143;
    PeAOrbitalVelocity:   8260;
    ApAOrbitalVelocity:   8145;
    MeanOrbitalVelocity:  8203;
    DrawInfo: (
      Color1:     $00C6DDE8;
      Color2:     $004B95B4;
      Color3:     $00376C84;
      ZoomRadius: 20000000;
    );
  );

//--- Saturn -------------------------------------------------------------------

  cSaturnInfo: TBodyInfo = (
    Name:                 'Saturn';
    Mass:                 568.36e24;
    ReducedMass:          568.36e13;
    Radius:               60268000;
    Periapsis:            1352550000000;
    Apoapsis:             1514500000000;
    SemiMajorAxis:        1433530000000;
    Eccentricity:         0.0565;
    Inclination:          2.485;
    OrbitalPeriod:        929596608;
    PeAOrbitalVelocity:   10180;
    ApAOrbitalVelocity:   9090;
    MeanOrbitalVelocity:  9680;
    DrawInfo: (
      Color1:     $00CAF3F9;
      Color2:     $001DCAE2;
      Color3:     $001699AB;
      ZoomRadius: 200000000;
    );
  );

//--- Titan --------------------------------------------------------------------

  cTitanInfo: TBodyInfo = (
    Name:                 'Titan';
    Mass:                 1345.5e20;
    ReducedMass:          1345.5e9;
    Radius:               2575000;
    Periapsis:            1186150000;
    Apoapsis:             1257510000;
    SemiMajorAxis:        1221830000;
    Eccentricity:         0.0292;
    Inclination:          0.33;
    OrbitalPeriod:        1377919;
    PeAOrbitalVelocity:   5737;
    ApAOrbitalVelocity:   5411;
    MeanOrbitalVelocity:  5570;
    DrawInfo: (
      Color1:     $00B5EAFB;
      Color2:     $000EB9F1;
      Color3:     $000B8AB5;
      ZoomRadius: 20000000;
    );
  );

//--- Uranus -------------------------------------------------------------------

  cUranusInfo: TBodyInfo = (
    Name:                 'Uranus';
    Mass:                 86.816e24;
    ReducedMass:          86.816e13;
    Radius:               25559000;
    Periapsis:            2741300000000;
    Apoapsis:             3003620000000;
    SemiMajorAxis:        2872460000000;
    Eccentricity:         0.0457;
    Inclination:          0.772;
    OrbitalPeriod:        2651218560;
    PeAOrbitalVelocity:   7110;
    ApAOrbitalVelocity:   6490;
    MeanOrbitalVelocity:  6800;
    DrawInfo: (
      Color1:     $00FFF1C1;
      Color2:     $00FFC600;
      Color3:     $00B38A00;
      ZoomRadius: 200000000;
    );
  );

//--- Neptune ------------------------------------------------------------------

  cNeptuneInfo: TBodyInfo = (
    Name:                 'Neptune';
    Mass:                 102.42e24;
    ReducedMass:          102.42e13;
    Radius:               24764000;
    Periapsis:            4444450000000;
    Apoapsis:             4545670000000;
    SemiMajorAxis:        4495060000000;
    Eccentricity:         0.0113;
    Inclination:          1.769;
    OrbitalPeriod:        5200329600;
    PeAOrbitalVelocity:   5500;
    ApAOrbitalVelocity:   5370;
    MeanOrbitalVelocity:  5430;
    DrawInfo: (
      Color1:     $00FFC4C7;
      Color2:     $00FF000D;
      Color3:     $009F0009;
      ZoomRadius: 200000000;
    );
  );

//--- Triton -------------------------------------------------------------------

  cTritonInfo: TBodyInfo = (
    Name:                 'Triton';
    Mass:                 214e20;
    ReducedMass:          214e9;
    Radius:               1353400;
    Periapsis:            354754323;
    Apoapsis:             354765676;
    SemiMajorAxis:        354760000;
    Eccentricity:         0.000016;
    Inclination:          157.345;
    OrbitalPeriod:        507842;
    PeAOrbitalVelocity:   -4389.3; (* retrograde orbit *)
    ApAOrbitalVelocity:   -4389.1;
    MeanOrbitalVelocity:  -4389.2;
    DrawInfo: (
      Color1:     $00AAFFD5;
      Color2:     $0000FF80;
      Color3:     $0000B359;
      ZoomRadius: 20000000;
    );
  );

//--- Pluto --------------------------------------------------------------------

  cPlutoInfo: TBodyInfo = (
    Name:                 'Pluto';
    Mass:                 1.31e22;
    ReducedMass:          1.31e11;
    Radius:               1195000;
    Periapsis:            4436820000000;
    Apoapsis:             7375930000000;
    SemiMajorAxis:        5906380000000;
    Eccentricity:         0.2488;
    Inclination:          17.16;
    OrbitalPeriod:        7816176000;
    PeAOrbitalVelocity:   6100;
    ApAOrbitalVelocity:   3710;
    MeanOrbitalVelocity:  4670;
    DrawInfo: (
      Color1:     $00D1D1D1;
      Color2:     $00808080;
      Color3:     $00535353;
      ZoomRadius: 20000000;
    );
  );

implementation

end.
