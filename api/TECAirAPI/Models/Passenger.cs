﻿using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TECAirAPI.Models;

/* The Passenger class represents a passenger with properties such as passenger number, email, check-in status, flight number, and collections of baggage, seats, and user information. */
public partial class Passenger
{
    public int Pnumber { get; set; }

    public string Uemail { get; set; } = null!;

    public bool CheckedIn { get; set; }

    public int Fno { get; set; }
    [JsonIgnore]
    public virtual ICollection<Baggage> Baggages { get; set; } = new List<Baggage>();
    [JsonIgnore]
    public virtual Flight FnoNavigation { get; set; } = null!;
    [JsonIgnore]
    public virtual ICollection<Seat> Seats { get; set; } = new List<Seat>();
    [JsonIgnore]
    public virtual Userw UemailNavigation { get; set; } = null!;
}
