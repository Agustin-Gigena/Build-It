namespace BuildIt.Maui;

public partial class MainPage : ContentPage
{
    public MainPage(IServiceProvider services)
    {
        InitializeComponent();
        Blazor.Services = services;
    }
}
