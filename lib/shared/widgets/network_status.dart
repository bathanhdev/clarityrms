import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clarityrms/core/global_state/network/network_cubit.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';

/// Widget đơn giản hiển thị thông báo mất kết nối mạng dạng inline nhỏ.
class NetworkStatus extends StatelessWidget {
  const NetworkStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        if (state is NetworkDisconnected) {
          return Padding(
            padding: AppSpacing.paddingHorizontalSm,
            child: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(right: AppSpacing.md),
                      child: Icon(
                        Icons.wifi_off,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Mất kết nối mạng. Vui lòng kiểm tra lại.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
