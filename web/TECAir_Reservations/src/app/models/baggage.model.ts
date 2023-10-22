export interface Baggage {
  bnumber?: number;
  weight: string;
  pemail?: string;
  baggagecolor: Color[];
}

export enum Color {
  rojo = 'rojo',
  blanco = 'blanco',
  azul = 'azul',
  negro = 'negro',
  verde = 'verde',
  amarillo = 'amarillo',
  gris = 'gris',
  cafe = 'cafe',
}

export const baggages: Baggage[] = [
  {
    weight: '10',
    baggagecolor: [Color.rojo, Color.verde],
  },
  {
    weight: '20',
    baggagecolor: [Color.rojo, Color.verde],
  },
  {
    weight: '30',
    baggagecolor: [Color.rojo, Color.amarillo, Color.verde],
  },
];

export const baggagesIDSelected: number[] = [99, 100, 101];

export interface CreateBaggage {
  pnumber: number;
  baggages: Baggage[];
}

export const createBaggageExample: CreateBaggage = {
  pnumber: 0,
  baggages: baggages,
};

export interface SimpleBaggage {
  bnumber: number;
}
